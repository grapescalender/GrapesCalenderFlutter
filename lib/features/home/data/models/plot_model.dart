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
    required DateTime pruningDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String soilType,
    @Default('') String variety,
    @Default('') String notes,
    @Default(true) bool isActive,
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
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(null) DateTime? endDate,
    @Default(true) bool isActive,
  }) = _RunningPlotModel;

  factory RunningPlotModel.fromJson(Map<String, dynamic> json) =>
      _$RunningPlotModelFromJson(json);
}

/// Schedule model (legacy — used only for local plot_model.dart context)
@freezed
class PlotScheduleModel with _$PlotScheduleModel {
  const factory PlotScheduleModel({
    required String id,
    required String plotId,
    required String type,
    required String title,
    required DateTime scheduledDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String description,
    @Default(null) DateTime? completedDate,
    @Default('pending') String status,
  }) = _PlotScheduleModel;

  factory PlotScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$PlotScheduleModelFromJson(json);
}

/// Activity model for sequential lifecycle activities (legacy)
@freezed
class PlotActivityModel with _$PlotActivityModel {
  const factory PlotActivityModel({
    required String id,
    required String plotId,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('pending') String status,
    @Default(0) int sequenceOrder,
    @Default(null) DateTime? startDate,
    @Default(null) DateTime? endDate,
  }) = _PlotActivityModel;

  factory PlotActivityModel.fromJson(Map<String, dynamic> json) =>
      _$PlotActivityModelFromJson(json);
}
