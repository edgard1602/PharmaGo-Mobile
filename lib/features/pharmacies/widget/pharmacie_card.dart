import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../model/pharmacie.dart';
import 'distance_badge.dart';

class PharmacieCard extends StatelessWidget {
  const PharmacieCard({
    required this.pharmacie,
    required this.onTap,
    super.key,
  });

  final Pharmacie pharmacie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header : nom + distance ───────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      pharmacie.nom,
                      style: AppTypography.headingSmall,
                    ),
                  ),
                  if (pharmacie.distanceFormatted != null) ...[
                    const SizedBox(width: 8),
                    DistanceBadge(distance: pharmacie.distanceFormatted!),
                  ],
                ],
              ),

              const SizedBox(height: 6),

              // ── Quartier ──────────────────────────────────────────────
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(pharmacie.quartier, style: AppTypography.bodyMedium),
                ],
              ),

              const SizedBox(height: 8),

              // ── Badge DE GARDE ────────────────────────────────────────
              _BadgeGarde(),

              const SizedBox(height: 10),

              // ── Téléphone ─────────────────────────────────────────────
              Row(
                children: [
                  const Icon(
                    Icons.phone_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(pharmacie.telephone, style: AppTypography.bodyMedium),
                ],
              ),

              const SizedBox(height: 12),

              // ── Boutons d'action ──────────────────────────────────────
              Row(
                children: [
                  _ActionButton(
                    label: 'Appeler',
                    icon: Icons.phone,
                    color: AppColors.primary,
                    onTap: () => _appeler(pharmacie.telephone),
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    label: 'WhatsApp',
                    icon: Icons.chat,
                    color: AppColors.whatsapp,
                    onTap: () => _whatsapp(pharmacie),
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    label: 'Itinéraire',
                    icon: Icons.navigation_outlined,
                    color: AppColors.accent,
                    onTap: () => _itineraire(pharmacie),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
  }

  Future<void> _appeler(String telephone) async {
    final uri = Uri(scheme: 'tel', path: telephone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _whatsapp(Pharmacie pharmacie) async {
    final numero = pharmacie.whatsappNumber.replaceAll('+', '');
    final message = Uri.encodeComponent(pharmacie.whatsappMessage);
    final uri = Uri.parse('https://wa.me/$numero?text=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _itineraire(Pharmacie pharmacie) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${pharmacie.latitude},${pharmacie.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Badge DE GARDE animé ──────────────────────────────────────────────────────

class _BadgeGarde extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .fadeOut(duration: 700.ms)
              .then()
              .fadeIn(duration: 700.ms),
          const SizedBox(width: 6),
          Text(
            'DE GARDE',
            style: AppTypography.labelSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// ── Bouton d'action ───────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.button.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}