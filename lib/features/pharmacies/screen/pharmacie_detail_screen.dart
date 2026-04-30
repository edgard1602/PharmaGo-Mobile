import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../provider/pharmacie_detail_provider.dart';
import '../../../shared/widget/error_widget.dart';

class PharmacieDetailScreen extends ConsumerWidget {
  const PharmacieDetailScreen({required this.pharmacieId, super.key});

  final int pharmacieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pharmacieAsync = ref.watch(pharmacieDetailProvider(pharmacieId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: pharmacieAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(pharmacieDetailProvider(pharmacieId)),
        ),
        data: (pharmacie) => CustomScrollView(
          slivers: [
            // ── AppBar avec nom ──────────────────────────────────────
            SliverAppBar(
              expandedHeight: 140,
              pinned: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: Text(
                  pharmacie.nom,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () => SharePlus.instance.share(
                    ShareParams(text: pharmacie.whatsappMessage),
                  ),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Badge DE GARDE ─────────────────────────────
                    Center(child: _BadgeGardeAnime()),

                    const SizedBox(height: 24),

                    // ── Infos principales ──────────────────────────
                    _SectionCard(
                      children: [
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          label: 'Quartier',
                          value: pharmacie.quartier,
                        ),
                        const Divider(),
                        _InfoRow(
                          icon: Icons.phone_outlined,
                          label: 'Téléphone',
                          value: pharmacie.telephone,
                        ),
                        if (pharmacie.whatsapp != null) ...[
                          const Divider(),
                          _InfoRow(
                            icon: Icons.chat_outlined,
                            label: 'WhatsApp',
                            value: pharmacie.whatsapp!,
                          ),
                        ],
                        if (pharmacie.distanceFormatted != null) ...[
                          const Divider(),
                          _InfoRow(
                            icon: Icons.straighten_outlined,
                            label: 'Distance',
                            value: pharmacie.distanceFormatted!,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Boutons d'action grands ────────────────────
                    _GrandBouton(
                      label: 'Appeler',
                      icon: Icons.phone_rounded,
                      color: AppColors.primary,
                      onTap: () => _appeler(pharmacie.telephone),
                    ),

                    const SizedBox(height: 10),

                    _GrandBouton(
                      label: 'Envoyer un message WhatsApp',
                      icon: Icons.chat_rounded,
                      color: AppColors.whatsapp,
                      onTap: () => _whatsapp(pharmacie.whatsappNumber,
                          pharmacie.whatsappMessage),
                    ),

                    const SizedBox(height: 10),

                    _GrandBouton(
                      label: 'Voir l\'itinéraire',
                      icon: Icons.navigation_rounded,
                      color: AppColors.accent,
                      onTap: () =>
                          _itineraire(pharmacie.latitude, pharmacie.longitude),
                    ),

                    const SizedBox(height: 32),

                    // ── Signaler une erreur ────────────────────────
                    Center(
                      child: TextButton.icon(
                        onPressed: () => context
                            .push('/signalement/${pharmacie.id}'),
                        icon: const Icon(
                          Icons.flag_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        label: const Text(
                          'Signaler une erreur',
                          style: AppTypography.bodyMedium,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _appeler(String telephone) async {
    final uri = Uri(scheme: 'tel', path: telephone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _whatsapp(String numero, String message) async {
    final n = numero.replaceAll('+', '');
    final m = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/$n?text=$m');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _itineraire(double lat, double lng) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Badge DE GARDE animé ──────────────────────────────────────────────────────

class _BadgeGardeAnime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scaleXY(begin: 1, end: 1.5, duration: 700.ms)
              .then()
              .scaleXY(begin: 1.5, end: 1, duration: 700.ms),
          const SizedBox(width: 8),
          Text(
            'DE GARDE',
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Grand bouton d'action ─────────────────────────────────────────────────────

class _GrandBouton extends StatelessWidget {
  const _GrandBouton({
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          textStyle: AppTypography.button.copyWith(fontSize: 15),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
  }
}

// ── Section card ──────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(children: children),
    );
  }
}

// ── Ligne d'info ──────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.bodyMedium),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}