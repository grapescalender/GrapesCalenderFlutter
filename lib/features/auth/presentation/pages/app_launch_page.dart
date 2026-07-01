import 'package:flutter/material.dart';

import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';

class AppLaunchPage extends StatelessWidget {
  const AppLaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusHuge),
                  ),
                  child: Icon(
                    Icons.agriculture_rounded,
                    size: 38,
                    color: cs.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Smart Farm',
                  style: AppTypography.titleLarge(context).copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CircularProgressIndicator(color: cs.primary),
                const SizedBox(height: AppSpacing.smMd),
                Text(
                  'Preparing your farm…',
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
