import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/distance_utils.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/plot_entity.dart';
import '../providers/plot_notifier.dart';

class PlotLocationSection extends ConsumerWidget {
  const PlotLocationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final plotState = ref.watch(plotNotifierProvider);

    final selectedId = plotState.selectedPlotId;
    PlotEntity? selected;
    if (selectedId != null) {
      try {
        selected = plotState.plots.firstWhere((p) => p.id == selectedId);
      } catch (_) {
        selected = null;
      }
    }

    if (selected == null || selected.latitude == null || selected.longitude == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plot Location',
              style: AppTypography.headlineMedium(context).copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard.defaultStyle(
              child: Row(
                children: [
                  Icon(Icons.map_outlined, color: cs.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Location not available for this plot',
                      style: AppTypography.bodyMedium(context).copyWith(color: cs.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final plotLat = selected.latitude!;
    final plotLon = selected.longitude!;

    final posAsync = ref.watch(currentPositionProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plot Location',
            style: AppTypography.headlineMedium(context).copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard.defaultStyle(
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(plotLat, plotLon),
                        zoom: 15,
                      ),
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      markers: {
                        Marker(
                          markerId: MarkerId('plot_${selected.id}'),
                          position: LatLng(plotLat, plotLon),
                        ),
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Icon(Icons.place_outlined, size: 18, color: cs.primary),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            selected.location,
                            style: AppTypography.bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        posAsync.when(
                          data: (pos) {
                            if (pos == null) {
                              return TextButton(
                                onPressed: () => ref.invalidate(currentPositionProvider),
                                child: const Text('Enable location'),
                              );
                            }
                            final km = DistanceUtils.haversineKm(
                              lat1: pos.latitude,
                              lon1: pos.longitude,
                              lat2: plotLat,
                              lon2: plotLon,
                            );
                            return Text(
                              '${km.toStringAsFixed(km >= 10 ? 0 : 1)} km',
                              style: AppTypography.bodySmall(context).copyWith(
                                color: cs.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                          loading: () => SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary),
                          ),
                          error: (_, __) => TextButton(
                            onPressed: () => ref.invalidate(currentPositionProvider),
                            child: const Text('Retry'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

