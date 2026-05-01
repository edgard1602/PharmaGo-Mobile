import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Système typographique de l'app.
/// On utilise TextStyle nommés → cohérence garantie.
/// Un senior ne met jamais fontSize: 16 directement dans un Widget.
abstract class AppTypography {
  // ── Famille de polices ────────────────────────────────────────────────────
  // Sur Android entrée de gamme, la police système est souvent Roboto
  // ou une variante locale. On utilise sans-serif natif pour la performance.
  // Pour un design premium on ajouterait google_fonts: Nunito ou DM Sans.
  static const String _fontFamily = 'Roboto'; // Pré-installé sur tout Android

  // ── Titres ────────────────────────────────────────────────────────────────
  static const TextStyle headingLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Corps ─────────────────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ── Labels / Badges ───────────────────────────────────────────────────────
  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // ── Boutons ───────────────────────────────────────────────────────────────
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
}