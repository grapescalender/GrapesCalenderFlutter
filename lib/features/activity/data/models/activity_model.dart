import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/activity_entity.dart';

part 'activity_model.freezed.dart';
part 'activity_model.g.dart';

/// Activity model for data layer
@freezed
class ActivityModel with _$ActivityModel {
  const factory ActivityModel({
    required String id,
    required String plotId,
    @Default('') String plotName,
    required String type, // cutting, flooring, formation, harvesting, dipping
    required String status, // pending, active, completed
    DateTime? startedAt,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);
}
