import '../../domain/entities/schedule_entity.dart';

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
    this.perWaterUnit = 'litre',
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
        'combinationName': combinationName,
        'products': products.map((product) => product.toMap()).toList(),
      };

  String get legacyDescription {
    final lines = <String>[
      if (instructions.isNotEmpty) instructions,
      if (notes.isNotEmpty) 'Notes: $notes',
      if (totalWaterQuantity != null)
        'Total water: ${_number(totalWaterQuantity!)} $totalWaterUnit',
      if (tankCount != null) 'Tank count: $tankCount',
      if (labourTeam?.isNotEmpty ?? false) 'Labour/team: $labourTeam',
      if (estimatedDuration?.isNotEmpty ?? false)
        'Estimated duration: $estimatedDuration',
      for (final product in products) _productLine(product),
    ];
    return lines.join('\n');
  }

  static String _number(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';

  static String _productLine(ScheduleProductDraft product) {
    return '${product.sequenceNo}. ${product.productName}: ${product.dose} '
        '${product.doseUnit} per ${product.perWaterQuantity} '
        '${product.perWaterUnit}';
  }
}
