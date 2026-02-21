import '../../domain/entities/schedule_entity.dart';
import '../models/schedule_model.dart';

/// Mapper to convert between ScheduleModel (data layer) and ScheduleEntity (domain layer)
class ScheduleMapper {
  /// Convert ScheduleModel to ScheduleEntity
  static ScheduleEntity toEntity(ScheduleModel model) {
    return ScheduleEntity(
      id: model.id,
      plotId: model.plotId,
      plotName: model.plotName,
      type: ScheduleType.fromString(model.type),
      title: model.title,
      scheduledDate: model.scheduledDate,
      description: model.description.isEmpty ? null : model.description,
      isCompleted: model.isCompleted,
      activityIds: model.activityIds,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert ScheduleEntity to ScheduleModel
  static ScheduleModel toModel(ScheduleEntity entity) {
    return ScheduleModel(
      id: entity.id,
      plotId: entity.plotId,
      plotName: entity.plotName,
      type: entity.type.value,
      title: entity.title,
      description: entity.description ?? '',
      scheduledDate: entity.scheduledDate,
      isCompleted: entity.isCompleted,
      activityIds: entity.activityIds,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
