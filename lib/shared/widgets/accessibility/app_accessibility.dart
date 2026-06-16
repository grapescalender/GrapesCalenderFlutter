import 'package:flutter/material.dart';

/// Minimum touch target per Material / WCAG guidance (48dp).
const double kMinTouchTarget = 48;

/// Wraps [child] with optional semantics for screen readers.
class AppSemantics extends StatelessWidget {

  const AppSemantics({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.value,
    this.button = false,
    this.header = false,
    this.enabled = true,
    this.onTap,
  });
  final Widget child;
  final String? label;
  final String? hint;
  final String? value;
  final bool button;
  final bool header;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
      label: label,
      hint: hint,
      value: value,
      button: button,
      header: header,
      enabled: enabled,
      onTap: onTap,
      child: child,
    );
}

/// Ensures interactive widgets meet minimum tap target size.
class AppMinTouchTarget extends StatelessWidget {

  const AppMinTouchTarget({
    super.key,
    required this.child,
    this.minSize = kMinTouchTarget,
  });
  final Widget child;
  final double minSize;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
      constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
      child: Align(alignment: Alignment.center, child: child),
    );
}
