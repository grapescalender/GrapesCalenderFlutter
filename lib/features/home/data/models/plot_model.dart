import 'package:freezed_annotation/freezed_annotation.dart';

part 'plot_model.freezed.dart';
part 'plot_model.g.dart';

/// Plot model for grape farming
@freezed
class PlotModel with _$PlotModel {
  const factory PlotModel({
    required String id,
    required String farmerId,
    required String name,
    required double area,
    @Default('') String soilType,
    @Default('') String variety,
    required DateTime pruningDate,
    @Default('') String notes,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PlotModel;

  factory PlotModel.fromJson(Map<String, dynamic> json) =>
      _$PlotModelFromJson(json);
}

/// Running plot model (plots currently in cultivation)
@freezed
class RunningPlotModel with _$RunningPlotModel {
  const factory RunningPlotModel({
    required String id,
    required String farmerId,
    required PlotModel plot,
    required DateTime startDate,
    @Default(null) DateTime? endDate,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RunningPlotModel;

  factory RunningPlotModel.fromJson(Map<String, dynamic> json) =>
      _$RunningPlotModelFromJson(json);
}

/// Schedule model
@freezed
class ScheduleModel with _$ScheduleModel {
  const factory ScheduleModel({
    required String id,
    required String plotId,
    required String type, // spray, nutrition, work
    required String title,
    @Default('') String description,
    required DateTime scheduledDate,
    @Default(null) DateTime? completedDate,
    @Default('pending') String status, // pending, completed, cancelled
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ScheduleModel;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);
}

/// Activity model for sequential lifecycle activities
@freezed
class ActivityModel with _$ActivityModel {
  const factory ActivityModel({
    required String id,
    required String plotId,
    required String name, // pruning, shoot_formation, flowering, etc
    @Default('pending') String status, // pending, active, completed
    @Default(0) int sequenceOrder,
    @Default(null) DateTime? startDate,
    @Default(null) DateTime? endDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);
}
