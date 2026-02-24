import 'package:flutter/material.dart';
import '../../core/design_system/spacing/app_spacing.dart';
import '../../core/design_system/typography/app_typography.dart';

/// Modern Button Widget
/// Minimal, clean button design with multiple variants
/// Supports primary, secondary, and text button styles
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  /// Primary button (filled)
  const AppButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    IconData? icon,
    bool isFullWidth = false,
  }) : this(
          key: key,
          label: label,
          onPressed: onPressed,
          variant: AppButtonVariant.primary,
          size: size,
          isLoading: isLoading,
          icon: icon,
          isFullWidth: isFullWidth,
        );

  /// Secondary button (outlined)
  const AppButton.secondary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    IconData? icon,
    bool isFullWidth = false,
  }) : this(
          key: key,
          label: label,
          onPressed: onPressed,
          variant: AppButtonVariant.secondary,
          size: size,
          isLoading: isLoading,
          icon: icon,
          isFullWidth: isFullWidth,
        );

  /// Text button
  const AppButton.text({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    IconData? icon,
    bool isFullWidth = false,
  }) : this(
          key: key,
          label: label,
          onPressed: onPressed,
          variant: AppButtonVariant.text,
          size: size,
          isLoading: isLoading,
          icon: icon,
          isFullWidth: isFullWidth,
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;
    
    final buttonStyle = _getButtonStyle(context, isDark);
    final buttonSize = _getButtonSize();
    final textStyle = _getTextStyle(context);

    Widget button;

    switch (variant) {
      case AppButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: _buildButtonContent(context, textStyle),
        );
        break;
      case AppButtonVariant.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: _buildButtonContent(context, textStyle),
        );
        break;
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: _buildButtonContent(context, textStyle),
        );
        break;
    }

    if (isFullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  ButtonStyle _getButtonStyle(BuildContext context, bool isDark) {
    final cs = Theme.of(context).colorScheme;
    final bgColor = backgroundColor ?? cs.primary;
    final fgColor = foregroundColor ?? cs.onPrimary;
    
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: AppSpacing.elevationMedium,
          padding: _getButtonSize(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          disabledBackgroundColor: cs.onSurface.withOpacity(0.12),
          disabledForegroundColor: cs.onSurface.withOpacity(0.38),
        );
      case AppButtonVariant.secondary:
        return OutlinedButton.styleFrom(
          foregroundColor: bgColor,
          padding: _getButtonSize(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          side: BorderSide(color: bgColor),
          disabledForegroundColor: cs.onSurface.withOpacity(0.38),
        );
      case AppButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: bgColor,
          padding: _getButtonSize(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          disabledForegroundColor: cs.onSurface.withOpacity(0.38),
        );
    }
  }

  EdgeInsets _getButtonSize() {
    switch (size) {
      case AppButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.buttonPaddingHorizontalSmall,
          vertical: AppSpacing.sm,
        );
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.buttonPaddingHorizontal,
          vertical: AppSpacing.buttonPaddingVertical,
        );
      case AppButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.labelMedium(context);
      case AppButtonSize.medium:
        return AppTypography.labelLarge(context);
      case AppButtonSize.large:
        return AppTypography.labelLarge(context).copyWith(
          fontSize: AppTypography.labelLarge(context).fontSize! + 2,
        );
    }
  }

  Widget _buildButtonContent(BuildContext context, TextStyle textStyle) {
    final cs = Theme.of(context).colorScheme;
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.primary
                ? cs.onPrimary
                : cs.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          SizedBox(width: AppSpacing.iconSpacing),
          Text(label, style: textStyle),
        ],
      );
    }

    return Text(label, style: textStyle);
  }
}

/// Button Variants
enum AppButtonVariant {
  primary,
  secondary,
  text,
}

/// Button Sizes
enum AppButtonSize {
  small,
  medium,
  large,
}
