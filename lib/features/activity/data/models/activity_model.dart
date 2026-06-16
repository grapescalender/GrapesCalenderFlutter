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
    required String type,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String plotName,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);
}
