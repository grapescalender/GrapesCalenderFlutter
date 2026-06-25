import 'package:flutter/material.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../domain/entities/schedule_entity.dart';

class ScheduleTypeColors {
  const ScheduleTypeColors._();

  static Color accent(ScheduleType type) {
    return switch (type) {
      ScheduleType.work => AppColors.chartAmber,
      ScheduleType.spray => AppColors.primary,
      ScheduleType.nutrition => AppColors.info,
      ScheduleType.water => AppColors.chartBlue,
      ScheduleType.all => AppColors.primary,
    };
  }

  static Color container(ScheduleType type) {
    return switch (type) {
      ScheduleType.work => AppColors.warningLight,
      ScheduleType.spray => AppColors.primaryContainer,
      ScheduleType.nutrition => AppColors.infoLight,
      ScheduleType.water => AppColors.infoLight,
      ScheduleType.all => AppColors.primaryContainer,
    };
  }
}
