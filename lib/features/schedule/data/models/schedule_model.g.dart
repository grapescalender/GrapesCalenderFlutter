// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleModelImpl _$$ScheduleModelImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleModelImpl(
      id: json['id'] as String,
      plotId: json['plotId'] as String,
      plotName: json['plotName'] as String? ?? '',
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      activityIds: (json['activityIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ScheduleModelImplToJson(_$ScheduleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plotId': instance.plotId,
      'plotName': instance.plotName,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'scheduledDate': instance.scheduledDate.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'activityIds': instance.activityIds,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
