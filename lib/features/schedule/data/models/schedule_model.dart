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
    required String type,
    required String title,
    required DateTime scheduledDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String plotName,
    @Default('') String description,
    @Default(false) bool isCompleted,
    @Default([]) List<String> activityIds,
  }) = _ScheduleModel;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);
}
