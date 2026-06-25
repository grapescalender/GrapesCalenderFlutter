import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm_pruning_manager/features/schedule/domain/entities/schedule_entity.dart';
import 'package:smart_farm_pruning_manager/features/schedule/presentation/models/add_schedule_request.dart';

void main() {
  group('AddScheduleRequest irrigation fields', () {
    test('stores drip duration as typed request fields and legacy text', () {
      final request = _request(
        scheduleType: ScheduleType.water,
        waterMethod: WaterMethod.drip,
        durationValue: 30,
        durationUnit: WaterDurationUnit.minutes,
      );

      expect(request.toMap(), containsPair('waterMethod', 'drip'));
      expect(request.toMap(), containsPair('durationValue', 30));
      expect(request.toMap(), containsPair('durationUnit', 'minutes'));
      expect(
          request.legacyDescription, contains('Water method: Drip Irrigation'));
      expect(request.legacyDescription, contains('Water duration: 30 Minutes'));
    });

    test('stores flooding quantity without duration', () {
      final request = _request(
        scheduleType: ScheduleType.water,
        waterMethod: WaterMethod.flooding,
        waterQuantity: 5000,
      );

      expect(request.toMap(), containsPair('waterMethod', 'flooding'));
      expect(request.toMap(), containsPair('waterQuantity', 5000));
      expect(request.toMap()['durationValue'], isNull);
      expect(request.legacyDescription, contains('Water quantity: 5000 Liter'));
    });

    test('stores nutrition irrigation as fertigation', () {
      final request = _request(
        scheduleType: ScheduleType.nutrition,
        waterMethod: WaterMethod.fertigation,
        durationValue: 2,
        durationUnit: WaterDurationUnit.hours,
      );

      expect(request.toMap(), containsPair('waterMethod', 'fertigation'));
      expect(
        request.legacyDescription,
        contains('Water method: Nutrition / Fertigation'),
      );
      expect(request.legacyDescription, contains('Water duration: 2 Hours'));
    });
  });
}

AddScheduleRequest _request({
  required ScheduleType scheduleType,
  required WaterMethod waterMethod,
  double? durationValue,
  WaterDurationUnit? durationUnit,
  double? waterQuantity,
}) =>
    AddScheduleRequest(
      plotId: 'plot-1',
      scheduleType: scheduleType,
      activityId: 'activity-1',
      stageId: 'flowering',
      scheduleDate: DateTime(2026, 6, 26),
      dueDate: DateTime(2026, 6, 26),
      totalWaterUnit: 'L',
      instructions: '',
      notes: '',
      products: const [],
      combinationName: '',
      waterMethod: waterMethod,
      durationValue: durationValue,
      durationUnit: durationUnit,
      waterQuantity: waterQuantity,
    );
