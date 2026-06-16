import 'package:flutter/material.dart';
import '../../responsive/responsive_utils.dart';

/// Applies consistent horizontal screen padding with optional max width.
class AppScreenPadding extends StatelessWidget {

  const AppScreenPadding({
    super.key,
    required this.child,
    this.padding,
    this.constrainWidth = false,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool constrainWidth;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? ResponsiveUtils.responsivePadding(context),
      child: child,
    );

    if (!constrainWidth) return content;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.maxContentWidth(context),
        ),
        child: content,
      ),
    );
  }
}
