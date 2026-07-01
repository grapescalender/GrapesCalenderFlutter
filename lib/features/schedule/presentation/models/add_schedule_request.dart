import '../../domain/entities/schedule_entity.dart';

String _scheduleUnitLabel(String unit) => unit == 'litre' ? 'liter' : unit;

enum WaterMethod {
  drip,
  flooding,
  fertigation;

  String get value => name;

  String get displayName => switch (this) {
        WaterMethod.drip => 'Drip Irrigation',
        WaterMethod.flooding => 'Flood Irrigation',
        WaterMethod.fertigation => 'Nutrition / Fertigation',
      };
}

enum WaterDurationUnit {
  minutes,
  hours;

  String get value => name;

  String get displayName => switch (this) {
        WaterDurationUnit.minutes => 'Minutes',
        WaterDurationUnit.hours => 'Hours',
      };
}

class ScheduleProductDraft {
  const ScheduleProductDraft({
    required this.productId,
    required this.productName,
    required this.categoryId,
    required this.categoryLabel,
    required this.manufacturer,
    required this.sequenceNo,
    this.dose = '',
    this.doseUnit = 'gm',
    this.perWaterQuantity = '',
    this.perWaterUnit = 'liter',
  });

  final String productId;
  final String productName;
  final String categoryId;
  final String categoryLabel;
  final String manufacturer;
  final String dose;
  final String doseUnit;
  final String perWaterQuantity;
  final String perWaterUnit;
  final int sequenceNo;

  ScheduleProductDraft copyWith({
    String? dose,
    String? doseUnit,
    String? perWaterQuantity,
    String? perWaterUnit,
    int? sequenceNo,
  }) =>
      ScheduleProductDraft(
        productId: productId,
        productName: productName,
        categoryId: categoryId,
        categoryLabel: categoryLabel,
        manufacturer: manufacturer,
        dose: dose ?? this.dose,
        doseUnit: doseUnit ?? this.doseUnit,
        perWaterQuantity: perWaterQuantity ?? this.perWaterQuantity,
        perWaterUnit: perWaterUnit ?? this.perWaterUnit,
        sequenceNo: sequenceNo ?? this.sequenceNo,
      );

  double? requiredQuantity(double? totalWater) {
    final doseValue = double.tryParse(dose);
    final perWaterValue = double.tryParse(perWaterQuantity);
    if (doseValue == null ||
        perWaterValue == null ||
        perWaterValue <= 0 ||
        totalWater == null) {
      return null;
    }
    return doseValue * totalWater / perWaterValue;
  }

  String get dosageSummary {
    if (dose.trim().isEmpty || perWaterQuantity.trim().isEmpty) {
      return 'Add dose and water quantity';
    }
    return '${dose.trim()} ${_scheduleUnitLabel(doseUnit)} / '
        '${perWaterQuantity.trim()} ${_scheduleUnitLabel(perWaterUnit)}';
  }

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'productName': productName,
        'categoryId': categoryId,
        'dose': double.tryParse(dose),
        'doseUnit': doseUnit,
        'perWaterQuantity': double.tryParse(perWaterQuantity),
        'perWaterUnit': perWaterUnit,
        'sequenceNo': sequenceNo,
      };
}

class AddScheduleRequest {
  const AddScheduleRequest({
    required this.plotId,
    required this.scheduleType,
    required this.activityId,
    required this.stageId,
    required this.scheduleDate,
    required this.dueDate,
    required this.totalWaterUnit,
    required this.instructions,
    required this.notes,
    required this.products,
    required this.combinationName,
    this.totalWaterQuantity,
    this.tankCount,
    this.labourTeam,
    this.estimatedDuration,
    this.waterMethod,
    this.durationValue,
    this.durationUnit,
    this.waterQuantity,
    this.waterQuantityUnit = 'Liter',
  });

  final String plotId;
  final ScheduleType scheduleType;
  final String activityId;
  final String stageId;
  final DateTime scheduleDate;
  final DateTime dueDate;
  final double? totalWaterQuantity;
  final String totalWaterUnit;
  final int? tankCount;
  final String instructions;
  final String notes;
  final String? labourTeam;
  final String? estimatedDuration;
  final WaterMethod? waterMethod;
  final double? durationValue;
  final WaterDurationUnit? durationUnit;
  final double? waterQuantity;
  final String waterQuantityUnit;
  final List<ScheduleProductDraft> products;
  final String combinationName;

  Map<String, dynamic> toMap() => {
        'plotId': plotId,
        'scheduleType': scheduleType.value,
        'activityId': activityId,
        'stageId': stageId,
        'scheduleDate': scheduleDate.toIso8601String(),
        'dueDate': dueDate.toIso8601String(),
        'totalWaterQuantity': totalWaterQuantity,
        'totalWaterUnit': totalWaterUnit,
        'tankCount': tankCount,
        'instructions': instructions,
        'notes': notes,
        'labourTeam': labourTeam,
        'estimatedDuration': estimatedDuration,
        'waterMethod': waterMethod?.value,
        'durationValue': durationValue,
        'durationUnit': durationUnit?.value,
        'waterQuantity': waterQuantity,
        'waterQuantityUnit': waterQuantityUnit,
        'combinationName': combinationName,
        'products': products.map((product) => product.toMap()).toList(),
      };

  String get legacyDescription {
    final lines = <String>[
      if (instructions.isNotEmpty) instructions,
      'Stage: $stageId',
      'Due date: ${dueDate.toIso8601String()}',
      if (notes.isNotEmpty) 'Notes: $notes',
      if (totalWaterQuantity != null)
        'Total water: ${_number(totalWaterQuantity!)} $totalWaterUnit',
      if (tankCount != null) 'Tank count: $tankCount',
      if (labourTeam?.isNotEmpty ?? false) 'Labour/team: $labourTeam',
      if (estimatedDuration?.isNotEmpty ?? false)
        'Estimated duration: $estimatedDuration',
      if (waterMethod != null) 'Water method: ${waterMethod!.displayName}',
      if (durationValue != null && durationUnit != null)
        'Water duration: ${_number(durationValue!)} ${durationUnit!.displayName}',
      if (waterQuantity != null)
        'Water quantity: ${_number(waterQuantity!)} $waterQuantityUnit',
      for (final product in products) _productLine(product),
    ];
    return lines.join('\n');
  }

  static String _number(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';

  static String _productLine(ScheduleProductDraft product) {
    return '${product.sequenceNo}. ${product.productName}: ${product.dose} '
        '${_scheduleUnitLabel(product.doseUnit)} per '
        '${product.perWaterQuantity} ${_scheduleUnitLabel(product.perWaterUnit)}';
  }
}
