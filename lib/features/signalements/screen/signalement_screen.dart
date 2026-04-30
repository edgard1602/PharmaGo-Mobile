import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../model/signalement.dart';
import '../provider/signalement_provider.dart';

class SignalementScreen extends ConsumerWidget {
  const SignalementScreen({required this.pharmacieId, super.key});

  final int pharmacieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signalementProvider);

    // Navigation automatique après succès
    ref.listen(signalementProvider, (_, next) {
      if (next.isSuccess) {
        _afficherSucces(context);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Signaler une erreur'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Introduction ───────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.accent,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Aidez-nous à améliorer PharmaGo en signalant les informations incorrectes.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Type d'erreur ──────────────────────────────────────
            Text("Type d'erreur", style: AppTypography.headingSmall),
            const SizedBox(height: 12),

            ...TypeSignalement.values.map(
              (type) => _TypeOption(
                type: type,
                isSelected: state.selectedType == type,
                onTap: () =>
                    ref.read(signalementProvider.notifier).setType(type),
              ),
            ),

            const SizedBox(height: 24),

            // ── Description ────────────────────────────────────────
            Text('Description', style: AppTypography.headingSmall),
            const SizedBox(height: 8),
            Text(
              'Décrivez le problème avec plus de détails',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 12),

            TextFormField(
              maxLines: 4,
              maxLength: 300,
              onChanged: (v) =>
                  ref.read(signalementProvider.notifier).setDescription(v),
              decoration: const InputDecoration(
                hintText: 'Ex: Le numéro de téléphone affiché est incorrect...',
              ),
            ),

            const SizedBox(height: 32),

            // ── Bouton envoyer ─────────────────────────────────────
            if (state.hasError) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.dangerLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.danger, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.danger),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isValid && !state.isLoading
                    ? () => ref
                        .read(signalementProvider.notifier)
                        .envoyer(pharmacieId)
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Envoyer le signalement'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _afficherSucces(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              'Merci pour votre signalement !',
              style: AppTypography.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Nous examinerons les informations et corrigerons si nécessaire.',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

// ── Option de type ────────────────────────────────────────────────────────────

class _TypeOption extends StatelessWidget {
  const _TypeOption({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final TypeSignalement type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              type.label,
              style: AppTypography.bodyLarge.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textPrimary,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}