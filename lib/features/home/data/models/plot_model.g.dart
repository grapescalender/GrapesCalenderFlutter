// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlotModelImpl _$$PlotModelImplFromJson(Map<String, dynamic> json) =>
    _$PlotModelImpl(
      id: json['id'] as String,
      farmerId: json['farmerId'] as String,
      name: json['name'] as String,
      area: (json['area'] as num).toDouble(),
      soilType: json['soilType'] as String? ?? '',
      variety: json['variety'] as String? ?? '',
      pruningDate: DateTime.parse(json['pruningDate'] as String),
      notes: json['notes'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PlotModelImplToJson(_$PlotModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmerId': instance.farmerId,
      'name': instance.name,
      'area': instance.area,
      'soilType': instance.soilType,
      'variety': instance.variety,
      'pruningDate': instance.pruningDate.toIso8601String(),
      'notes': instance.notes,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$RunningPlotModelImpl _$$RunningPlotModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RunningPlotModelImpl(
      id: json['id'] as String,
      farmerId: json['farmerId'] as String,
      plot: PlotModel.fromJson(json['plot'] as Map<String, dynamic>),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RunningPlotModelImplToJson(
        _$RunningPlotModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmerId': instance.farmerId,
      'plot': instance.plot,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$ScheduleModelImpl _$$ScheduleModelImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleModelImpl(
      id: json['id'] as String,
      plotId: json['plotId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      completedDate: json['completedDate'] == null
          ? null
          : DateTime.parse(json['completedDate'] as String),
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ScheduleModelImplToJson(_$ScheduleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plotId': instance.plotId,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'scheduledDate': instance.scheduledDate.toIso8601String(),
      'completedDate': instance.completedDate?.toIso8601String(),
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$ActivityModelImpl _$$ActivityModelImplFromJson(Map<String, dynamic> json) =>
    _$ActivityModelImpl(
      id: json['id'] as String,
      plotId: json['plotId'] as String,
      name: json['name'] as String,
      status: json['status'] as String? ?? 'pending',
      sequenceOrder: (json['sequenceOrder'] as num?)?.toInt() ?? 0,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ActivityModelImplToJson(_$ActivityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plotId': instance.plotId,
      'name': instance.name,
      'status': instance.status,
      'sequenceOrder': instance.sequenceOrder,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
