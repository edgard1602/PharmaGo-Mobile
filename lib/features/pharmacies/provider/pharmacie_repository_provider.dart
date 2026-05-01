import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/provider/shared_preferences_provider.dart';
import '../repository/pharmacie_repository.dart';

final pharmacieRepositoryProvider = Provider<PharmacieRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PharmacieRepository(prefs: prefs);
});