import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/pharmacie.dart';
import 'pharmacie_repository_provider.dart';

/// FutureProvider.family — "family" permet de passer un paramètre (l'id).
/// POURQUOI FutureProvider ici et pas StateNotifierProvider comme la liste ?
/// → L'écran détail est en lecture seule — on charge, on affiche, c'est tout.
/// → FutureProvider gère automatiquement les états loading/data/error.
/// → Pas besoin de méthodes supplémentaires.
final pharmacieDetailProvider =
    FutureProvider.family<Pharmacie, int>((ref, id) async {
  final repo = ref.watch(pharmacieRepositoryProvider);
  return repo.getPharmacieById(id);
});