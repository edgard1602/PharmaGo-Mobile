import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/signalement.dart';
import '../repository/signalement_repository.dart';

// ── Provider du repository ────────────────────────────────────────────────────

final signalementRepositoryProvider = Provider<SignalementRepository>((ref) {
  return SignalementRepository();
});

// ── State ─────────────────────────────────────────────────────────────────────

enum SignalementStatus { initial, loading, success, error }

class SignalementState {
  const SignalementState({
    this.status = SignalementStatus.initial,
    this.errorMessage,
    this.selectedType,
    this.description = '',
  });

  final SignalementStatus status;
  final String? errorMessage;
  final TypeSignalement? selectedType;
  final String description;

  bool get isLoading => status == SignalementStatus.loading;
  bool get isSuccess => status == SignalementStatus.success;
  bool get hasError => status == SignalementStatus.error;

  /// Formulaire valide si type sélectionné et description non vide
  bool get isValid =>
      selectedType != null && description.trim().isNotEmpty;

  SignalementState copyWith({
    SignalementStatus? status,
    String? errorMessage,
    TypeSignalement? selectedType,
    String? description,
  }) {
    return SignalementState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedType: selectedType ?? this.selectedType,
      description: description ?? this.description,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class SignalementNotifier extends StateNotifier<SignalementState> {
  SignalementNotifier(this._ref) : super(const SignalementState());

  final Ref _ref;

  void setType(TypeSignalement type) {
    state = state.copyWith(selectedType: type);
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
  }

  Future<void> envoyer(int pharmacieId) async {
    if (!state.isValid) return;

    state = state.copyWith(status: SignalementStatus.loading);

    try {
      final repo = _ref.read(signalementRepositoryProvider);
      await repo.envoyer(
        Signalement(
          pharmacieId: pharmacieId,
          type: state.selectedType!,
          description: state.description.trim(),
        ),
      );
      state = state.copyWith(status: SignalementStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: SignalementStatus.error,
        errorMessage: 'Impossible d\'envoyer le signalement. Réessayez.',
      );
    }
  }
}

// ── Provider exposé ───────────────────────────────────────────────────────────

final signalementProvider =
    StateNotifierProvider.autoDispose<SignalementNotifier, SignalementState>(
  (ref) => SignalementNotifier(ref),
);