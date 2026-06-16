import 'package:flutter/material.dart';
import '../responsive/responsive_utils.dart';

/// Responsive wrapper widget that adapts layout based on screen size
class ResponsiveWrapper extends StatelessWidget {

  const ResponsiveWrapper({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (ResponsiveUtils.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);
  final Widget Function(BuildContext context, bool isMobile, bool isTablet, bool isDesktop) builder;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return builder(context, isMobile, isTablet, isDesktop);
  }
}
