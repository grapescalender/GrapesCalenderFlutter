import '../../domain/entities/activity_entity.dart';
import '../models/activity_model.dart';

/// Mapper to convert between ActivityModel (data layer) and ActivityEntity (domain layer)
class ActivityMapper {
  /// Convert ActivityModel to ActivityEntity
  static ActivityEntity toEntity(ActivityModel model) {
    return ActivityEntity(
      id: model.id,
      plotId: model.plotId,
      plotName: model.plotName,
      type: ActivityType.fromString(model.type),
      status: ActivityStatus.fromString(model.status),
      startedAt: model.startedAt,
      completedAt: model.completedAt,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert ActivityEntity to ActivityModel
  static ActivityModel toModel(ActivityEntity entity) {
    return ActivityModel(
      id: entity.id,
      plotId: entity.plotId,
      plotName: entity.plotName,
      type: entity.type.value,
      status: entity.status.value,
      startedAt: entity.startedAt,
      completedAt: entity.completedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
