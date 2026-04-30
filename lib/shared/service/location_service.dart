import 'package:geolocator/geolocator.dart';

// Correction import — chemin relatif correct depuis shared/service/
import '../../core/error/app_exception.dart';

class LocationService {
  /// Tente d'obtenir la position actuelle.
  /// Gère toute la logique de permissions proprement.
  /// Lance une [LocationException] si indisponible.
  Future<Position> getCurrentPosition() async {
    // 1. Le service GPS est-il activé sur l'appareil ?
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        'Le GPS est désactivé. Activez-le dans les paramètres.',
      );
    }

    // 2. Vérification des permissions
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // On demande la permission — s'affiche une seule fois
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException(
          'Permission de localisation refusée.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // L'utilisateur a coché "Ne plus demander"
      // On ne peut plus demander — il faut aller dans les paramètres
      throw const LocationException(
        'Localisation bloquée définitivement. '
        'Activez-la dans les paramètres de l\'application.',
      );
    }

    // 3. Récupération de la position
    // On utilise LocationAccuracy.medium pour économiser la batterie
    // sur Android entrée de gamme — pas besoin de précision GPS max
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (_) {
      throw const LocationException('Impossible d\'obtenir votre position.');
    }
  }
}