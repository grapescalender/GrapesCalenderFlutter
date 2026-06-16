import 'package:flutter/material.dart';

/// UI status colors for schedules/activities (pending/completed/upcoming/active).
class AppStatusColors extends ThemeExtension<AppStatusColors> {

  const AppStatusColors({
    required this.pending,
    required this.completed,
    required this.upcoming,
    required this.active,
  });
  final Color pending;
  final Color completed;
  final Color upcoming;
  final Color active;

  static const AppStatusColors light = AppStatusColors(
    pending: Colors.orange,
    completed: Colors.green,
    upcoming: Colors.grey,
    active: Colors.indigo,
  );

  static const AppStatusColors dark = AppStatusColors(
    pending: Colors.orangeAccent,
    completed: Colors.lightGreenAccent,
    upcoming: Colors.grey,
    active: Colors.indigoAccent,
  );

  @override
  AppStatusColors copyWith({
    Color? pending,
    Color? completed,
    Color? upcoming,
    Color? active,
  }) => AppStatusColors(
      pending: pending ?? this.pending,
      completed: completed ?? this.completed,
      upcoming: upcoming ?? this.upcoming,
      active: active ?? this.active,
    );

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      pending: Color.lerp(pending, other.pending, t) ?? pending,
      completed: Color.lerp(completed, other.completed, t) ?? completed,
      upcoming: Color.lerp(upcoming, other.upcoming, t) ?? upcoming,
      active: Color.lerp(active, other.active, t) ?? active,
    );
  }
}

