import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/schedule_entity.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

/// Schedule model for data layer
@freezed
class ScheduleModel with _$ScheduleModel {
  const factory ScheduleModel({
    required String id,
    required String plotId,
    @Default('') String plotName,
    required String type, // spray, nutrition, work
    required String title,
    @Default('') String description,
    required DateTime scheduledDate,
    @Default(false) bool isCompleted,
    @Default([]) List<String> activityIds, // 1-2 activity IDs
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ScheduleModel;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);
}
