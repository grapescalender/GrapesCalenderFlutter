// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleModelImpl _$$ScheduleModelImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleModelImpl(
      id: json['id'] as String,
      plotId: json['plotId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      plotName: json['plotName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      activityIds: (json['activityIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ScheduleModelImplToJson(_$ScheduleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plotId': instance.plotId,
      'type': instance.type,
      'title': instance.title,
      'scheduledDate': instance.scheduledDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'plotName': instance.plotName,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'activityIds': instance.activityIds,
    };
