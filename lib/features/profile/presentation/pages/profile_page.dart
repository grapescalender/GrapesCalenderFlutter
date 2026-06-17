import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/design_system/theme/app_theme_provider.dart';

/// Profile Page — premium redesign
/// All existing actions preserved. Dark mode toggle wired to themeModeProvider.
/// Logout navigates to login route.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ────────────────────────────────────────────────
            const SliverToBoxAdapter(child: _ProfileHeader()),

            // ── Farm Info Card ────────────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    AppSpacing.smMd,
                    AppSpacing.screenHorizontal,
                    0),
                child: _FarmInfoCard(),
              ),
            ),

            // ── Account Section ───────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                    AppSpacing.md, AppSpacing.screenHorizontal, 0),
                child: Text('Account',
                    style: AppTypography.headlineSmall(context)
                        .copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                    AppSpacing.smMd, AppSpacing.screenHorizontal, 0),
                child: _SettingsGroup(
                  items: [
                    _SettingItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit Profile',
                      onTap: () {},
                    ),
                    _SettingItem(
                      icon: Icons.lock_outline_rounded,
                      label: 'Change Password',
                      onTap: () {},
                    ),
                    _SettingItem(
                      icon: Icons.language_rounded,
                      label: 'Change Language',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // ── Preferences Section ───────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                    AppSpacing.md, AppSpacing.screenHorizontal, 0),
                child: Text('Preferences',
                    style: AppTypography.headlineSmall(context)
                        .copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                    AppSpacing.smMd, AppSpacing.screenHorizontal, 0),
                child: _SettingsGroup(
                  items: [
                    _SettingItem(
                      icon: isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      label: 'Dark Mode',
                      trailing: Switch(
                        value: isDark,
                        onChanged: (_) => ref
                            .read(themeModeProvider.notifier)
                            .toggleTheme(),
                        activeColor: AppColors.primary,
                      ),
                      onTap: () => ref
                          .read(themeModeProvider.notifier)
                          .toggleTheme(),
                    ),
                    _SettingItem(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // ── Support Section ───────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                    AppSpacing.md, AppSpacing.screenHorizontal, 0),
                child: Text('Support',
                    style: AppTypography.headlineSmall(context)
                        .copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                    AppSpacing.smMd, AppSpacing.screenHorizontal, 0),
                child: _SettingsGroup(
                  items: [
                    _SettingItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & FAQ',
                      onTap: () {},
                    ),
                    _SettingItem(
                      icon: Icons.info_outline_rounded,
                      label: 'About App',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // ── Logout ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                    AppSpacing.md, AppSpacing.screenHorizontal, AppSpacing.xl),
                child: _LogoutButton(
                  onTap: () => context.go(AppRoutes.login),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Profile Header ────────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
          AppSpacing.lg, AppSpacing.screenHorizontal, AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.outline),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Center(
              child: Text('S',
                  style: AppTypography.headlineLarge(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  )),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Name & email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Farmer Name',
                    style: AppTypography.headlineMedium(context)
                        .copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('farmer@example.com',
                    style: AppTypography.bodySmall(context)
                        .copyWith(color: AppColors.onSurface)),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded,
                          size: 12, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text('Farm Owner',
                          style: AppTypography.bodySmall(context).copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Edit icon
          IconButton(
            onPressed: () {},
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: AppColors.outline),
              ),
              child: const Icon(Icons.edit_outlined,
                  size: 18, color: AppColors.onBackground),
            ),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

// ── Farm Info Card ────────────────────────────────────────────────────────────
class _FarmInfoCard extends StatelessWidget {
  const _FarmInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(Icons.agriculture_rounded,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Farm',
                    style: AppTypography.bodySmall(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    )),
                Text('Table Grapes Farm',
                    style: AppTypography.headlineSmall(context).copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    )),
                Text('Maharashtra, India',
                    style: AppTypography.bodySmall(context).copyWith(
                      color: AppColors.primary,
                      fontSize: 11,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Settings Group ────────────────────────────────────────────────────────────
class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.items});
  final List<_SettingItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isLast = i == items.length - 1;
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      i == 0 ? AppSpacing.radiusLg : 0),
                  topRight: Radius.circular(
                      i == 0 ? AppSpacing.radiusLg : 0),
                  bottomLeft: Radius.circular(
                      isLast ? AppSpacing.radiusLg : 0),
                  bottomRight: Radius.circular(
                      isLast ? AppSpacing.radiusLg : 0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.smMd),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Icon(item.icon,
                            size: 18, color: AppColors.onBackground),
                      ),
                      const SizedBox(width: AppSpacing.smMd),
                      Expanded(
                        child: Text(item.label,
                            style: AppTypography.bodyMedium(context)
                                .copyWith(
                                    color: AppColors.onBackground,
                                    fontWeight: FontWeight.w500)),
                      ),
                      if (item.trailing != null)
                        item.trailing!
                      else
                        const Icon(Icons.chevron_right_rounded,
                            size: 20, color: AppColors.onSurface),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const Divider(
                    height: 1,
                    indent: AppSpacing.md + 36 + AppSpacing.smMd,
                    color: AppColors.outline),
            ],
          );
        }),
      ),
    );
  }
}

class _SettingItem {
  const _SettingItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
}

// ── Logout Button ─────────────────────────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.smMd),
        decoration: BoxDecoration(
          color: AppColors.errorLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
              color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded,
                size: 20, color: AppColors.error),
            const SizedBox(width: AppSpacing.sm),
            Text('Log Out',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ),
    );
  }
}
