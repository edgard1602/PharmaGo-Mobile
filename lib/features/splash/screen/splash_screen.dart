import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigation automatique après 2.5 secondes
    // On utilise Future.delayed + mounted check pour éviter
    // les erreurs si le widget est disposé avant la navigation
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) context.go('/pharmacies');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Logo ──────────────────────────────────────────────────
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.local_pharmacy_rounded,
                size: 56,
                color: AppColors.primary,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scaleXY(begin: 0.7, end: 1, duration: 600.ms,
                    curve: Curves.easeOutBack),

            const SizedBox(height: 24),

            // ── Nom de l'app ──────────────────────────────────────────
            Text(
              'PharmaGo',
              style: AppTypography.headingLarge.copyWith(
                color: Colors.white,
                fontSize: 32,
                letterSpacing: 1,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 500.ms)
                .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 500.ms),

            const SizedBox(height: 12),

            // ── Tagline ───────────────────────────────────────────────
            Text(
              'Votre pharmacie de garde, toujours proche',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 700.ms, duration: 500.ms),

            const SizedBox(height: 60),

            // ── Indicateur de chargement discret ─────────────────────
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white54,
              ),
            )
                .animate()
                .fadeIn(delay: 1000.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}