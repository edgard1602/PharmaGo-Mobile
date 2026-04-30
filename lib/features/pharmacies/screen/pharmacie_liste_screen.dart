import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widget/loading_widget.dart';
import '../../../shared/widget/error_widget.dart';
import '../../../shared/widget/empty_widget.dart';
import '../provider/pharmacie_provider.dart';
import '../widget/pharmacie_card.dart';

class PharmacieListScreen extends ConsumerWidget {
  const PharmacieListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pharmacieListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PharmaGo'),
            if (state.userPosition != null)
              Text(
                'Près de vous',
                style: AppTypography.bodyMedium.copyWith(fontSize: 11),
              )
            else if (state.selectedQuartier != null)
              Text(
                state.selectedQuartier!,
                style: AppTypography.bodyMedium.copyWith(fontSize: 11),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () =>
                ref.read(pharmacieListProvider.notifier).retry(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Bandeau offline ─────────────────────────────────────────
          if (state.isOffline) _OfflineBanner(state.lastUpdateFormatted),

          // ── Filtre quartier ─────────────────────────────────────────
          if (state.userPosition == null) _QuartierFilter(ref),

          // ── Contenu principal ───────────────────────────────────────
          Expanded(
            child: _buildBody(context, ref, state),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, PharmacieListState state) {
    if (state.isLoading) return const PharmacieSkeletonList();

    if (state.hasError) {
      return AppErrorWidget(
        message: state.errorMessage!,
        onRetry: () => ref.read(pharmacieListProvider.notifier).retry(),
      );
    }

    if (state.isEmpty) return const EmptyWidget();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.pharmacies.length,
      itemBuilder: (context, index) {
        final pharmacie = state.pharmacies[index];
        return PharmacieCard(
          pharmacie: pharmacie,
          onTap: () => context.push('/pharmacies/${pharmacie.id}'),
        );
      },
    );
  }
}

// ── Bandeau offline ───────────────────────────────────────────────────────────

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner(this.lastUpdate);
  final String lastUpdate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.dangerLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 16, color: AppColors.danger),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Mode hors ligne — $lastUpdate',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.danger,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filtre par quartier ───────────────────────────────────────────────────────

class _QuartierFilter extends ConsumerWidget {
  const _QuartierFilter(this.ref);
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quartiersAsync = ref.watch(quartiersProvider);

    return quartiersAsync.when(
      loading: () => const SizedBox(height: 56),
      error: (_, __) => const SizedBox.shrink(),
      data: (quartiers) {
        final state = ref.watch(pharmacieListProvider);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: AppColors.surface,
          child: DropdownButtonFormField<String>(
            value: state.selectedQuartier,
            hint: const Text('Choisir un quartier'),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: quartiers
                .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                .toList(),
            onChanged: (quartier) {
              if (quartier != null) {
                ref
                    .read(pharmacieListProvider.notifier)
                    .chargerParQuartier(quartier);
              }
            },
          ),
        );
      },
    );
  }
}