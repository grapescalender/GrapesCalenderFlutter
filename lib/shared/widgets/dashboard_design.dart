import 'package:flutter/material.dart';

import '../../core/design_system/colors/app_colors.dart';
import '../../core/design_system/spacing/app_spacing.dart';
import '../../core/design_system/typography/app_typography.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.smMd),
    this.margin,
    this.color = AppColors.surface,
    this.borderColor = AppColors.outline,
    this.onTap,
    this.radius = AppSpacing.radiusLg,
    this.showShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final Color borderColor;
  final VoidCallback? onTap;
  final double radius;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color == AppColors.surface ? colors.surface : color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color:
              borderColor == AppColors.outline ? colors.outline : borderColor,
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );

    final content = onTap == null
        ? card
        : Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(radius),
              child: card,
            ),
          );

    if (margin == null) return content;
    return Padding(padding: margin!, child: content);
  }
}

class DashboardSectionHeader extends StatelessWidget {
  const DashboardSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.horizontalPadding = AppSpacing.screenHorizontal,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: colors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleLarge(context).copyWith(
                    color: colors.onBackground,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: AppSpacing.sm),
            action!,
          ],
        ],
      ),
    );
  }
}

class DashboardIconButton extends StatelessWidget {
  const DashboardIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(color: colors.primary.withValues(alpha: 0.18)),
          ),
          child: Icon(icon, color: colors.primary, size: 18),
        ),
      ),
    );
  }
}

class DashboardPill extends StatelessWidget {
  const DashboardPill({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.selected = true,
    this.onTap,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    final foreground = selected ? color : colors.onSurface;
    final background =
        selected ? color.withValues(alpha: 0.12) : colors.background;
    final border = selected ? color.withValues(alpha: 0.22) : colors.outline;

    final pill = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.smMd,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: foreground),
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(
            child: Text(
              label,
              style: AppTypography.labelLarge(context).copyWith(
                color: foreground,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return pill;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: pill,
    );
  }
}

class DashboardField {
  const DashboardField._();

  static InputDecoration decoration({
    required BuildContext context,
    required String label,
    String? hint,
    IconData? icon,
  }) {
    final colors = DashboardStyle.of(context);
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon, size: 18),
      labelStyle: AppTypography.bodyMedium(context).copyWith(
        color: colors.onSurfaceVariant,
      ),
      hintStyle: AppTypography.labelLarge(context).copyWith(
        color: colors.onSurfaceVariant,
      ),
      filled: true,
      fillColor: colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: colors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: colors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: colors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: colors.error),
      ),
    );
  }
}

class DashboardStyle {
  const DashboardStyle._(this.colorScheme, this.isDark);

  final ColorScheme colorScheme;
  final bool isDark;

  static DashboardStyle of(BuildContext context) {
    final theme = Theme.of(context);
    return DashboardStyle._(
      theme.colorScheme,
      theme.brightness == Brightness.dark,
    );
  }

  Color get primary => colorScheme.primary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  Color get background => colorScheme.surfaceContainerLowest;
  Color get surface => colorScheme.surface;
  Color get surfaceVariant => colorScheme.surfaceContainerHighest;
  Color get outline => colorScheme.outlineVariant;
  Color get outlineStrong => colorScheme.outline;
  Color get onBackground => colorScheme.onSurface;
  Color get onSurface => colorScheme.onSurface;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;
  Color get onSurfaceDisabled => colorScheme.onSurface.withValues(alpha: 0.38);
  Color get error => colorScheme.error;
  Color get shadow => (isDark ? AppColors.darkShadow : AppColors.shadow)
      .withValues(alpha: 0.12);

  BoxDecoration cardDecoration({
    bool selected = false,
    Color? accentColor,
    double radius = AppSpacing.radiusXl,
  }) {
    final accent = accentColor ?? primary;
    return BoxDecoration(
      color: selected ? accent.withValues(alpha: 0.12) : surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: selected ? accent.withValues(alpha: 0.42) : outline,
        width: selected ? 1.5 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: shadow,
          blurRadius: AppSpacing.lg,
          offset: const Offset(0, AppSpacing.xs),
        ),
      ],
    );
  }
}

class DashboardBottomSheetFrame extends StatelessWidget {
  const DashboardBottomSheetFrame({
    super.key,
    required this.child,
    this.maxHeightFactor = 0.72,
    this.padding,
  });

  final Widget child;
  final double maxHeightFactor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * maxHeightFactor,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusHuge),
            ),
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: padding ??
                EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.smMd,
                  AppSpacing.screenHorizontal,
                  AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
                ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class DashboardSheetHeader extends StatelessWidget {
  const DashboardSheetHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  final String title;
  final String subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(child: DashboardDragHandle()),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            if (icon != null) ...[
              Container(
                width: AppSpacing.xl,
                height: AppSpacing.xl,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: colors.primary,
                  size: AppSpacing.mdLg,
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleLarge(context).copyWith(
                      color: colors.onBackground,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.labelLarge(context).copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DashboardDragHandle extends StatelessWidget {
  const DashboardDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return Container(
      width: AppSpacing.xl,
      height: 4,
      decoration: BoxDecoration(
        color: colors.outlineStrong,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
    );
  }
}

class DashboardSectionCard extends StatelessWidget {
  const DashboardSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.action,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: colors.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: AppSpacing.mdLg, color: colors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleMedium(context).copyWith(
                    color: colors.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (action != null) action!,
            ],
          ),
          const SizedBox(height: AppSpacing.smMd),
          child,
        ],
      ),
    );
  }
}

class DashboardListItem extends StatelessWidget {
  const DashboardListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.enabled = true,
    this.accentColor,
    this.meta,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final bool enabled;
  final Color? accentColor;
  final String? meta;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    final accent = accentColor ?? colors.primary;
    final titleColor = enabled
        ? selected
            ? accent
            : colors.onBackground
        : colors.onSurfaceDisabled;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(AppSpacing.smMd),
          decoration: colors
              .cardDecoration(
            selected: selected,
            accentColor: accent,
            radius: AppSpacing.radiusMd,
          )
              .copyWith(
            boxShadow: const [],
          ),
          child: Row(
            children: [
              Container(
                width: AppSpacing.xxl,
                height: AppSpacing.xxl,
                decoration: BoxDecoration(
                  color: enabled
                      ? accent.withValues(alpha: selected ? 0.14 : 0.1)
                      : colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                    color: enabled
                        ? accent.withValues(alpha: 0.22)
                        : colors.outline,
                  ),
                ),
                child: Icon(
                  icon,
                  color: enabled ? accent : colors.onSurfaceDisabled,
                  size: AppSpacing.mdLg,
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleMedium(context).copyWith(
                        color: titleColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: AppTypography.labelLarge(context).copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (meta != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        meta!,
                        style: AppTypography.labelLarge(context).copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardStatusPill extends StatelessWidget {
  const DashboardStatusPill({
    super.key,
    required this.label,
    required this.color,
    this.muted = false,
  });

  final String label;
  final Color color;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: muted ? colors.surfaceVariant : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.labelLarge(context).copyWith(
          color: muted ? colors.onSurfaceVariant : color,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
