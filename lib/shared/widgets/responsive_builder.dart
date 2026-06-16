import 'package:flutter/material.dart';

/// Responsive widget builder for different screen sizes
typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  DeviceType deviceType,
);

/// Device type classification
enum DeviceType {
  mobile,    // < 600 dp
  tablet,    // 600-900 dp
  desktop,   // >= 900 dp
}

/// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
    this.padding,
    this.backgroundColor,
  }) : super(key: key);
  final ResponsiveWidgetBuilder builder;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = _getDeviceType(constraints.maxWidth);
        
        Widget child = builder(context, constraints, deviceType);
        
        if (padding != null) {
          child = Padding(padding: padding!, child: child);
        }
        
        if (backgroundColor != null) {
          child = Container(
            color: backgroundColor,
            child: child,
          );
        }
        
        return child;
      },
    );

  static DeviceType _getDeviceType(double width) {
    if (width >= 900) return DeviceType.desktop;
    if (width >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}

/// Get device type based on width
DeviceType getDeviceType(double width) {
  if (width >= 900) return DeviceType.desktop;
  if (width >= 600) return DeviceType.tablet;
  return DeviceType.mobile;
}

/// Check if device is mobile
bool isMobile(double width) => width < 600;

/// Check if device is tablet
bool isTablet(double width) => width >= 600 && width < 900;

/// Check if device is desktop
bool isDesktop(double width) => width >= 900;
