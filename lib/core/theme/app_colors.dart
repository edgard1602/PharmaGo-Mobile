import 'package:flutter/material.dart';

/// Palette de couleurs PharmaGo.
/// Règle d'or : on ne met JAMAIS de Color() directement dans les widgets.
/// On passe toujours par AppColors → le jour où le design change,
/// on modifie ici, pas dans 50 fichiers.
abstract class AppColors {
  // ── Primaires ─────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF00A651);       // Vert médical
  static const Color primaryLight = Color(0xFFE8F7EF);  // Fond vert clair
  static const Color primaryDark = Color(0xFF007A3C);   // Hover / pressed

  // ── Secondaires ───────────────────────────────────────────────────────────
  static const Color accent = Color(0xFF0066CC);        // Bleu action
  static const Color accentLight = Color(0xFFE6F0FF);

  // ── Sémantiques ───────────────────────────────────────────────────────────
  static const Color danger = Color(0xFFE63946);        // Urgence / erreur
  static const Color dangerLight = Color(0xFFFDECEE);
  static const Color whatsapp = Color(0xFF25D366);      // Couleur officielle WA

  // ── Neutres ───────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8F9FA);    // Fond général
  static const Color surface = Color(0xFFFFFFFF);       // Cards
  static const Color textPrimary = Color(0xFF212529);   // Texte principal
  static const Color textSecondary = Color(0xFF6C757D); // Texte secondaire
  static const Color border = Color(0xFFDEE2E6);        // Bordures légères

  // ── Skeleton loader ───────────────────────────────────────────────────────
  static const Color skeletonBase = Color(0xFFE9ECEF);
  static const Color skeletonHighlight = Color(0xFFF8F9FA);
}