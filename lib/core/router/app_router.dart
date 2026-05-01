import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/screen/splash_screen.dart';
import '../../features/pharmacies/screen/pharmacie_list_screen.dart';
import '../../features/pharmacies/screen/pharmacie_detail_screen.dart';
import '../../features/signalements/screen/signalement_screen.dart';

/// Toutes les routes de l'app.
/// go_router est le router officiel Flutter — remplace Navigator 1.0
/// Avantages : deep links, web support, type safety
class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true, // Logs routing en debug uniquement
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/pharmacies',
        builder: (_, __) => const PharmacieListScreen(),
      ),
      GoRoute(
        path: '/pharmacies/:id',
        builder: (context, state) {
          // On passe l'ID en paramètre, le détail le charge depuis le provider
          final id = int.parse(state.pathParameters['id']!);
          return PharmacieDetailScreen(pharmacieId: id);
        },
      ),
      GoRoute(
        path: '/signalement/:pharmacieId',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['pharmacieId']!);
          return SignalementScreen(pharmacieId: id);
        },
      ),
    ],
  );
}