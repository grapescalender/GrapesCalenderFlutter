import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../activity/presentation/providers/activity_providers.dart';
import '../../domain/entities/plot_entity.dart';
import '../providers/plot_notifier.dart';
import '../providers/plot_state.dart';

/// Plot Section — compact hero gradient card.
///
/// Layout:
///   ┌──────────────────────────────────────────────────────────┐  ─┐
///   │  Selected Plot                                            │   │
///   │  P1 - Thompson Seedless ▾                                 │   │
///   │  [April Cycle] of Season 2026-27                          │   │
///   │  [08 Jun] [58] [Berry Setting]                            │   │
///   │  [View Plot Details →]                                    │   │
///   └──────────────────────────────────────────────────────────┘  ─┘
class PlotsSection extends ConsumerWidget {
  const PlotsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final state = ref.watch(plotNotifierProvider);
    final notifier = ref.read(plotNotifierProvider.notifier);
    final activityState = ref.watch(activityNotifierProvider);

    if (state.plots.isEmpty) return const SizedBox.shrink();

    final plot = state.plots.firstWhere(
      (p) => p.id == state.selectedPlotId,
      orElse: () => state.plots.first,
    );

    // Active or first pending activity — used for the chip label only
    final activeActivity = activityState.activities.isEmpty
        ? null
        : activityState.activities.where((a) => a.isActive).firstOrNull ??
            activityState.activities.where((a) => a.isPending).firstOrNull;

    final seasonName = _seasonName(plot.pruningDate);
    final cycleName = _cycleName(plot.pruningDate);
    final stageName = activeActivity != null
        ? activeActivity.type.displayName
        : _deriveStage(plot.daysSincePruning);
    final displayVariety = _displayVariety(plot.cropType);
    final selectedPlotLabel = '${plot.name} - $displayVariety';
    final showCompleteAprilCycle = _shouldShowCompleteAprilCycle(plot);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.lerp(cs.primary, Colors.black, 0.06) ?? cs.primary,
            cs.primary,
            Color.lerp(cs.secondary, Colors.white, 0.08) ?? cs.secondary,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Stack(
          children: [
            Positioned(
              left: -58,
              top: -68,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.09),
                ),
              ),
            ),
            Positioned(
              left: 34,
              top: -24,
              child: Transform.rotate(
                angle: -0.45,
                child: Container(
                  width: 210,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -46,
              bottom: -56,
              child: Container(
                width: 146,
                height: 146,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              right: -6,
              top: 56,
              child: Opacity(
                opacity: 0.42,
                child: _GrapePainting(size: 76),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.smMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _openSelector(context, state, notifier),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.smMd,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.24),
                            Colors.white.withValues(alpha: 0.12),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.34),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Plot',
                            style: AppTypography.labelSmall(context).copyWith(
                              color: Colors.white.withValues(alpha: 0.72),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedPlotLabel,
                                  style: AppTypography.titleLarge(context)
                                      .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    height: 1.05,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.smMd),
                  Row(
                    children: [
                      _CycleChip(label: cycleName),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'of $seasonName',
                          style: AppTypography.labelMedium(context).copyWith(
                            color: Colors.white.withValues(alpha: 0.78),
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.smMd),
                  Row(
                    children: [
                      Expanded(
                        child: _HeroMetricBox(
                          value: _formatDateShort(plot.pruningDate),
                          label: 'Cutting Date',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: _HeroMetricBox(
                          value: plot.hasPruningDate
                              ? '${plot.daysSincePruning}'
                              : '—',
                          label: 'Days After Pruning',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: _HeroMetricBox(
                          label: 'Current Activity',
                          valueWidget: _HeroStatusPill(label: stageName),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.smMd),
                  Row(
                    children: [
                      _HeroActionButton(
                        label: 'View Plot Details',
                        icon: Icons.arrow_forward_rounded,
                        onTap: () => _openPlotDetails(context, plot),
                      ),
                      if (showCompleteAprilCycle) ...[
                        const SizedBox(width: AppSpacing.xs),
                        _HeroActionButton(
                          label: 'Complete Cycle',
                          icon: Icons.task_alt_rounded,
                          compact: true,
                          onTap: () => _pickNextCycleDate(
                            context,
                            notifier,
                            plot,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── helpers ─────────────────────────────────────────────────────────────────

  void _openSelector(
      BuildContext context, PlotState state, PlotNotifier notifier) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.smMd),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: const Icon(Icons.agriculture_rounded,
                        color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: AppSpacing.smMd),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Plot',
                          style: AppTypography.headlineSmall(context)
                              .copyWith(fontWeight: FontWeight.w700)),
                      Text('Tap a plot to switch',
                          style: AppTypography.bodySmall(context)
                              .copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                  AppSpacing.sm, AppSpacing.screenHorizontal, AppSpacing.md),
              itemCount: state.plots.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) {
                final p = state.plots[i];
                final isSel = state.selectedPlotId == p.id;
                return GestureDetector(
                  onTap: () {
                    notifier.selectPlot(p.id);
                    Navigator.of(context).pop();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.smMd, vertical: AppSpacing.smMd),
                    decoration: BoxDecoration(
                      color: isSel
                          ? AppColors.primaryContainer
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: isSel
                            ? AppColors.primary.withValues(alpha: 0.40)
                            : AppColors.outline,
                        width: isSel ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Farm icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppColors.primary.withValues(alpha: 0.12)
                                : AppColors.surface,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                            border: Border.all(
                                color: isSel
                                    ? AppColors.primary.withValues(alpha: 0.25)
                                    : AppColors.outline),
                          ),
                          child: Icon(Icons.agriculture_rounded,
                              color: isSel
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                              size: 18),
                        ),
                        const SizedBox(width: AppSpacing.smMd),

                        // Plot info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style:
                                    AppTypography.titleLarge(context).copyWith(
                                  color: isSel
                                      ? AppColors.primary
                                      : AppColors.onBackground,
                                  fontWeight:
                                      isSel ? FontWeight.w700 : FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    '${p.cropType}  ·  ${p.area} ha',
                                    style: AppTypography.bodySmall(context)
                                        .copyWith(
                                            color: AppColors.onSurfaceVariant),
                                  ),
                                  if (p.hasPruningDate) ...[
                                    Text(
                                      '  ·  Day ${p.daysSincePruning}',
                                      style: AppTypography.bodySmall(context)
                                          .copyWith(
                                        color: isSel
                                            ? AppColors.primary
                                            : AppColors.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Selection indicator
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isSel ? AppColors.primary : Colors.transparent,
                            border: Border.all(
                              color:
                                  isSel ? AppColors.primary : AppColors.outline,
                              width: 1.5,
                            ),
                          ),
                          child: isSel
                              ? const Icon(Icons.check_rounded,
                                  size: 13, color: Colors.white)
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openPlotDetails(BuildContext context, PlotEntity plot) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PlotDetailsSheet(plot: plot),
    );
  }

  String _deriveStage(int days) {
    if (days <= 14) return 'Post-pruning: Shoot Emergence';
    if (days <= 35) return 'Vegetative Growth';
    if (days <= 70) return 'Berry Setting';
    return 'Ripening & Canopy';
  }

  String _cycleName(DateTime? pruningDate) {
    if (pruningDate == null) return 'Cycle not set';
    if (pruningDate.month >= DateTime.april &&
        pruningDate.month <= DateTime.september) {
      return 'April Cycle';
    }
    return 'October Cycle';
  }

  String _formatDateShort(DateTime? dt) {
    if (dt == null) return '—';
    return DateFormat('dd MMM').format(dt);
  }

  String _seasonName(DateTime? dt) {
    if (dt == null) return 'Season not set';
    final nextYear = ((dt.year + 1) % 100).toString().padLeft(2, '0');
    return 'Season ${dt.year}-$nextYear';
  }

  String _displayVariety(String cropType) {
    if (cropType.trim().isEmpty || cropType.toLowerCase() == 'grapes') {
      return 'Thompson Seedless';
    }
    return cropType;
  }

  bool _shouldShowCompleteAprilCycle(PlotEntity plot) {
    final pruningDate = plot.pruningDate;
    if (pruningDate == null || plot.hasScheduledNextPruningDate) return false;
    final isAprilCycle = pruningDate.month >= DateTime.april &&
        pruningDate.month <= DateTime.september;
    return isAprilCycle && plot.daysSincePruning >= 100;
  }

  Future<void> _pickNextCycleDate(
    BuildContext context,
    PlotNotifier notifier,
    PlotEntity plot,
  ) async {
    final now = DateTime.now();
    final currentPruning = plot.pruningDate ?? now;
    final octoberDate = DateTime(currentPruning.year, DateTime.october);
    final initialDate = octoberDate.isBefore(now) ? now : octoberDate;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2, DateTime.december, 31),
      helpText: 'Next cycle pruning date',
    );

    if (selectedDate == null || !context.mounted) return;

    notifier.completeAprilCycleAndScheduleNext(
      plotId: plot.id,
      nextPruningDate: selectedDate,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          selectedDate.isAfter(DateTime.now())
              ? 'Next cycle scheduled for ${DateFormat('dd MMM yyyy').format(selectedDate)}'
              : 'Next cycle started',
        ),
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: compact ? 1 : 2,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? AppSpacing.sm : AppSpacing.smMd,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white.withValues(alpha: 0.88),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.labelMedium(context).copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, size: 13, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _CycleChip extends StatelessWidget {
  const _CycleChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withValues(alpha: 0.88),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.46)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium(context).copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _HeroStatusPill extends StatelessWidget {
  const _HeroStatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.smMd,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withValues(alpha: 0.88),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.52)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall(context).copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _HeroMetricBox extends StatelessWidget {
  const _HeroMetricBox({
    required this.label,
    this.value,
    this.valueWidget,
  });

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.24),
            Colors.white.withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          valueWidget ??
              Text(
                value ?? '—',
                style: AppTypography.titleLarge(context).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall(context).copyWith(
              color: Colors.white.withValues(alpha: 0.74),
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _GrapePainting extends StatelessWidget {
  const _GrapePainting({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GrapePaintingPainter()),
    );
  }
}

class _GrapePaintingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = w * 0.085;
    final cx = w * 0.52;
    final startY = h * 0.24;
    final rowGap = r * 1.85;

    final berryFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.24)
      ..style = PaintingStyle.fill;
    final berryStroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final highlight = Paint()
      ..color = Colors.white.withValues(alpha: 0.38)
      ..style = PaintingStyle.fill;
    final stemPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final rows = <List<Offset>>[
      [Offset(cx, startY)],
      [
        Offset(cx - r * 1.05, startY + rowGap),
        Offset(cx + r * 1.05, startY + rowGap),
      ],
      [
        Offset(cx - r * 2.1, startY + rowGap * 2),
        Offset(cx, startY + rowGap * 2),
        Offset(cx + r * 2.1, startY + rowGap * 2),
      ],
      [
        Offset(cx - r * 1.05, startY + rowGap * 3),
        Offset(cx + r * 1.05, startY + rowGap * 3),
      ],
      [Offset(cx, startY + rowGap * 4)],
    ];

    for (final row in rows) {
      for (final center in row) {
        canvas.drawCircle(center, r, berryFill);
        canvas.drawCircle(center, r, berryStroke);
        canvas.drawCircle(
          Offset(center.dx - r * 0.28, center.dy - r * 0.28),
          r * 0.24,
          highlight,
        );
      }
    }

    final topBerry = rows.first.first;
    final stemTop = Offset(cx, h * 0.06);
    final stemPath = Path()
      ..moveTo(topBerry.dx, topBerry.dy - r)
      ..cubicTo(
        topBerry.dx,
        topBerry.dy - r - h * 0.04,
        stemTop.dx + w * 0.03,
        stemTop.dy + h * 0.04,
        stemTop.dx,
        stemTop.dy,
      );
    canvas.drawPath(stemPath, stemPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Plot Details Bottom Sheet ─────────────────────────────────────────────────
class _PlotDetailsSheet extends StatefulWidget {
  const _PlotDetailsSheet({required this.plot});
  final PlotEntity plot;

  @override
  State<_PlotDetailsSheet> createState() => _PlotDetailsSheetState();
}

class _PlotDetailsSheetState extends State<_PlotDetailsSheet> {
  final List<String> _seasons = ['2024-25', '2025-26', '2026-27'];
  String _selectedSeason = '2025-26';

  @override
  Widget build(BuildContext context) {
    final plot = widget.plot;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (ctx, ctrl) => ListView(
            controller: ctrl,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal),
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: AppSpacing.smMd),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Plot Details',
                            style: AppTypography.headlineMedium(context)
                                .copyWith(fontWeight: FontWeight.w700)),
                        Text(plot.name,
                            style: AppTypography.bodyMedium(context)
                                .copyWith(color: AppColors.onSurface)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Plot Info
              _SectionCard(
                title: 'Plot Information',
                icon: Icons.info_outline_rounded,
                children: [
                  _InfoRow(
                      label: 'Variety',
                      value: plot.cropType.isNotEmpty ? plot.cropType : '—'),
                  _InfoRow(label: 'Area', value: '${plot.area} hectares'),
                  _InfoRow(label: 'Soil Type', value: '—'),
                  _InfoRow(
                    label: 'Pruning Date',
                    value: plot.pruningDate != null
                        ? DateFormat('d MMM yyyy').format(plot.pruningDate!)
                        : 'Not set',
                  ),
                  _InfoRow(
                      label: 'Current Stage',
                      value: _stage(plot.daysSincePruning)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Schedules
              _SectionCard(
                title: 'Schedules',
                icon: Icons.calendar_month_rounded,
                trailing: _SeasonDropdown(
                  seasons: _seasons,
                  selected: _selectedSeason,
                  onChanged: (v) => setState(() => _selectedSeason = v),
                ),
                children: [
                  ..._mockSchedules().map((s) => _ScheduleRow(
                        title: s['title']!,
                        type: s['type']!,
                        date: s['date']!,
                      )),
                  const SizedBox(height: AppSpacing.sm),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('View All Schedules',
                            style: AppTypography.labelMedium(context).copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_rounded,
                            size: 13, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  String _stage(int days) {
    if (days <= 14) return 'Shoot Emergence';
    if (days <= 35) return 'Vegetative Growth';
    if (days <= 70) return 'Berry Setting';
    return 'Ripening & Canopy';
  }

  List<Map<String, String>> _mockSchedules() => [
        {'title': 'Pesticide Spray Round 1', 'type': 'Spray', 'date': 'Today'},
        {'title': 'NPK Fertilizer', 'type': 'Nutrition', 'date': 'Tomorrow'},
        {'title': 'Pruning Work', 'type': 'Work', 'date': 'In 3 days'},
        {
          'title': 'Fungicide Application',
          'type': 'Spray',
          'date': 'In 5 days'
        },
        {'title': 'Water Irrigation', 'type': 'Water', 'date': 'In 7 days'},
      ];
}

// ── Reusable sheet helpers ────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd, vertical: AppSpacing.smMd),
            child: Row(
              children: [
                Icon(icon, size: 15, color: AppColors.primary),
                const SizedBox(width: AppSpacing.xs),
                Text(title,
                    style: AppTypography.titleLarge(context)
                        .copyWith(fontWeight: FontWeight.w700)),
                if (trailing != null) ...[
                  const Spacer(),
                  trailing!,
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outline),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.smMd),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: AppTypography.bodySmall(context)
                    .copyWith(color: AppColors.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(value,
                style: AppTypography.bodyMedium(context)
                    .copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _SeasonDropdown extends StatelessWidget {
  const _SeasonDropdown(
      {required this.seasons, required this.selected, required this.onChanged});
  final List<String> seasons;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        color: AppColors.background,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          isDense: true,
          style: AppTypography.labelMedium(context)
              .copyWith(color: AppColors.onBackground),
          icon: const Icon(Icons.expand_more_rounded,
              size: 16, color: AppColors.onSurface),
          items: seasons
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow(
      {required this.title, required this.type, required this.date});
  final String title;
  final String type;
  final String date;

  Color _color(BuildContext ctx) {
    if (type == 'Spray' || type == 'Water') return AppColors.info;
    if (type == 'Nutrition') return AppColors.warning;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final c = _color(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 32,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.titleSmall(context)
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('$type  ·  $date',
                    style: AppTypography.bodySmall(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
