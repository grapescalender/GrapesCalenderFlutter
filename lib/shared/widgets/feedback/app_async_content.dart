import 'package:flutter/material.dart';
import '../../../core/design_system/spacing/app_spacing.dart';
import '../states/async_view_status.dart';
import 'app_empty_state.dart';
import 'app_error_state.dart';
import 'app_loading_state.dart';

/// Orchestrates loading / error / empty / success UI with consistent UX.
///
/// Usage:
/// ```dart
/// AppAsyncContent(
///   status: plotState.isLoading
///       ? AsyncViewStatus.loading
///       : plotState.errorMessage != null
///           ? AsyncViewStatus.error
///           : plotState.plots.isEmpty
///               ? AsyncViewStatus.empty
///               : AsyncViewStatus.success,
///   errorMessage: plotState.errorMessage,
///   emptyTitle: 'No plots found',
///   onRetry: notifier.loadPlots,
///   loading: AppLoadingState.horizontalCards(cardWidth: 240, cardHeight: 120),
///   builder: (context) => _PlotList(...),
/// )
/// ```
class AppAsyncContent extends StatelessWidget {
  final AsyncViewStatus status;
  final Widget Function(BuildContext context) builder;

  // Error
  final String? errorTitle;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool inlineError;

  // Empty
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData? emptyIcon;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;
  final bool compactEmpty;

  // Loading — custom widget or default list skeleton
  final Widget? loading;

  const AppAsyncContent({
    super.key,
    required this.status,
    required this.builder,
    this.errorTitle,
    this.errorMessage,
    this.onRetry,
    this.inlineError = false,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon,
    this.emptyActionLabel,
    this.onEmptyAction,
    this.compactEmpty = false,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AsyncViewStatus.loading:
        return loading ??
            const AppLoadingState.listRows(itemCount: 3, itemHeight: 56);
      case AsyncViewStatus.error:
        return AppErrorState(
          title: errorTitle ?? 'Something went wrong',
          message: errorMessage,
          onRetry: onRetry,
          inline: inlineError,
        );
      case AsyncViewStatus.empty:
        return AppEmptyState(
          icon: emptyIcon ?? Icons.inbox_outlined,
          title: emptyTitle ?? 'Nothing here yet',
          subtitle: emptySubtitle,
          actionLabel: emptyActionLabel,
          onAction: onEmptyAction,
          compact: compactEmpty,
        );
      case AsyncViewStatus.success:
        return builder(context);
    }
  }
}
