import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../shared/service/location_service.dart';
import '../model/pharmacie.dart';
import 'pharmacie_repository_provider.dart';
import '../../../core/error/app_exception.dart';

// ── State ────────────────────────────────────────────────────────────────────

/// État de la liste des pharmacies.
/// On utilise une classe d'état explicite plutôt qu'un AsyncValue brut
/// car on a besoin de stocker des infos supplémentaires :
/// - est-on en mode offline ?
/// - quelle est la date du cache ?
/// - quel filtre est actif (géoloc ou quartier) ?
class PharmacieListState {
  const PharmacieListState({
    this.pharmacies = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isOffline = false,
    this.lastUpdate,
    this.selectedQuartier,
    this.userPosition,
  });

  final List<Pharmacie> pharmacies;
  final bool isLoading;
  final String? errorMessage;
  final bool isOffline;
  final DateTime? lastUpdate;
  final String? selectedQuartier;    // null = mode géoloc
  final Position? userPosition;

  bool get hasError => errorMessage != null;
  bool get isEmpty => !isLoading && pharmacies.isEmpty && !hasError;

  /// Formatage de la date de mise à jour pour l'affichage
  String get lastUpdateFormatted {
    if (lastUpdate == null) return '';
    final d = lastUpdate!;
    return 'Mis à jour le ${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')} '
        'à ${d.hour.toString().padLeft(2, '0')}h'
        '${d.minute.toString().padLeft(2, '0')}';
  }

  PharmacieListState copyWith({
    List<Pharmacie>? pharmacies,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isOffline,
    DateTime? lastUpdate,
    String? selectedQuartier,
    bool clearQuartier = false,
    Position? userPosition,
  }) {
    return PharmacieListState(
      pharmacies: pharmacies ?? this.pharmacies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isOffline: isOffline ?? this.isOffline,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      selectedQuartier:
          clearQuartier ? null : selectedQuartier ?? this.selectedQuartier,
      userPosition: userPosition ?? this.userPosition,
    );
  }
}

// ── Provider LocationService ──────────────────────────────────────────────────

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// ── Notifier ─────────────────────────────────────────────────────────────────

/// Le Notifier gère toute la logique métier de la liste.
/// POURQUOI un Notifier et pas un FutureProvider ?
/// → On a besoin de méthodes : chargerParQuartier(), retry(), etc.
/// → On gère un état complexe avec plusieurs champs
/// → Un FutureProvider est en lecture seule — ici on veut des actions
class PharmacieListNotifier extends StateNotifier<PharmacieListState> {
  PharmacieListNotifier(this._ref) : super(const PharmacieListState()) {
    // Chargement automatique au démarrage
    chargerPharmacies();
  }

  final Ref _ref;

  /// Point d'entrée principal.
  /// Tente la géoloc → fallback quartier si refusée → fallback cache si offline
  Future<void> chargerPharmacies() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final repo = _ref.read(pharmacieRepositoryProvider);
    final locationService = _ref.read(locationServiceProvider);

    try {
      // Tentative géolocalisation
      final position = await locationService.getCurrentPosition();

      final pharmacies = await repo.getPharmaciesParGeoloc(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      state = state.copyWith(
        pharmacies: pharmacies,
        isLoading: false,
        isOffline: false,
        userPosition: position,
        lastUpdate: repo.lastCacheUpdate,
        clearQuartier: true,
      );
    } on LocationException {
      // Géoloc refusée ou indisponible → on charge sans filtre
      // L'UI affichera le sélecteur de quartier
      await _chargerSansGeoloc();
    } catch (e) {
      // Réseau KO → on tente le cache
      await _fallbackCache();
    }
  }

  /// Chargement par quartier (appelé depuis l'UI via le dropdown)
  Future<void> chargerParQuartier(String quartier) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      selectedQuartier: quartier,
    );

    final repo = _ref.read(pharmacieRepositoryProvider);

    try {
      final pharmacies = await repo.getPharmaciesParQuartier(quartier);
      state = state.copyWith(
        pharmacies: pharmacies,
        isLoading: false,
        isOffline: false,
        lastUpdate: repo.lastCacheUpdate,
      );
    } catch (e) {
      await _fallbackCache();
    }
  }

  /// Retry manuel (bouton "Réessayer" sur l'écran d'erreur)
  Future<void> retry() => chargerPharmacies();

  // ── Privé ─────────────────────────────────────────────────────────────────

  Future<void> _chargerSansGeoloc() async {
    final repo = _ref.read(pharmacieRepositoryProvider);
    try {
      final pharmacies = await repo.getAllPharmaciesGarde();
      state = state.copyWith(
        pharmacies: pharmacies,
        isLoading: false,
        isOffline: false,
        lastUpdate: repo.lastCacheUpdate,
      );
    } catch (e) {
      await _fallbackCache();
    }
  }

  Future<void> _fallbackCache() async {
    final repo = _ref.read(pharmacieRepositoryProvider);
    try {
      final pharmacies = await repo.getPharmaciesFromCache();
      state = state.copyWith(
        pharmacies: pharmacies,
        isLoading: false,
        isOffline: true,
        lastUpdate: repo.lastCacheUpdate,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Impossible de charger les pharmacies. '
            'Vérifiez votre connexion.',
      );
    }
  }
}

// ── Provider exposé à l'UI ────────────────────────────────────────────────────

final pharmacieListProvider =
    StateNotifierProvider<PharmacieListNotifier, PharmacieListState>(
  (ref) => PharmacieListNotifier(ref),
);

// ── Provider liste des quartiers ──────────────────────────────────────────────

final quartiersProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(pharmacieRepositoryProvider);
  return repo.getQuartiers();
});