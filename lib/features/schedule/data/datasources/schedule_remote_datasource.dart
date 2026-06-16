import '../../../../core/error/exceptions.dart';
import '../models/schedule_model.dart';

/// Remote data source for schedules
abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleModel>> getSchedules({
    required String plotId,
    String? type,
    int? limit,
  });

  Future<ScheduleModel> createSchedule(ScheduleModel schedule);
  Future<ScheduleModel> updateSchedule(ScheduleModel schedule);
  Future<void> deleteSchedule(String scheduleId);
}

/// Implementation of ScheduleRemoteDataSource
class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  @override
  Future<List<ScheduleModel>> getSchedules({
    required String plotId,
    String? type,
    int? limit,
  }) async {
    // TODO: Implement actual API call
    // Mock implementation for development
    await Future.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();
    final mockSchedules = [
      // Spray Schedules (5 items)
      ScheduleModel(
        id: '1',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'spray',
        title: 'Pesticide Spray - Round 1',
        description: 'Apply pesticide spray to control pests',
        scheduledDate: now.add(const Duration(days: 1)),
        activityIds: ['activity_${plotId}_flooring'], // Linked to Flooring activity
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      ScheduleModel(
        id: '2',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'spray',
        title: 'Pesticide Spray - Round 2',
        description: 'Second round of pesticide application',
        scheduledDate: now.subtract(const Duration(days: 2)), // Within Flooring activity range
        activityIds: ['activity_${plotId}_flooring', 'activity_${plotId}_formation'], // Linked to 2 activities
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(days: 8)),
      ),
      ScheduleModel(
        id: '3',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'spray',
        title: 'Fungicide Application',
        description: 'Apply fungicide to prevent diseases',
        scheduledDate: now.add(const Duration(days: 15)),
        activityIds: ['activity_${plotId}_formation'], // Linked to Formation activity
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      ScheduleModel(
        id: '4',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'spray',
        title: 'Herbicide Spray',
        description: 'Apply herbicide to control weeds',
        scheduledDate: now.add(const Duration(days: 20)),
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      ScheduleModel(
        id: '5',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'spray',
        title: 'Pesticide Spray - Round 3',
        description: 'Third round of pesticide application',
        scheduledDate: now.add(const Duration(days: 25)),
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      
      // Nutrition Schedules (5 items)
      ScheduleModel(
        id: '6',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'nutrition',
        title: 'NPK Fertilizer Application',
        description: 'Apply NPK fertilizer for growth',
        scheduledDate: now, // Today - within Flooring activity range (started 3 days ago, ongoing)
        activityIds: ['activity_${plotId}_flooring'], // Linked to Flooring activity (within date range)
        createdAt: now.subtract(const Duration(days: 9)),
        updatedAt: now.subtract(const Duration(days: 9)),
      ),
      ScheduleModel(
        id: '7',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'nutrition',
        title: 'Organic Compost Application',
        description: 'Apply organic compost for soil health',
        scheduledDate: now.subtract(const Duration(days: 1)), // Within Flooring activity range
        activityIds: ['activity_${plotId}_flooring'], // Linked to Flooring activity
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),
      ScheduleModel(
        id: '8',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'nutrition',
        title: 'Micronutrient Supplement',
        description: 'Apply micronutrients for better yield',
        scheduledDate: now.add(const Duration(days: 17)),
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      ScheduleModel(
        id: '9',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'nutrition',
        title: 'Liquid Fertilizer Application',
        description: 'Apply liquid fertilizer through irrigation',
        scheduledDate: now.add(const Duration(days: 22)),
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      ScheduleModel(
        id: '10',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'nutrition',
        title: 'NPK Fertilizer - Second Round',
        description: 'Second round of NPK fertilizer',
        scheduledDate: now.add(const Duration(days: 28)),
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
      
      // Work Schedules (5 items)
      ScheduleModel(
        id: '11',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'work',
        title: 'Pruning Work',
        description: 'Prune branches for better growth',
        scheduledDate: now.subtract(const Duration(days: 2)), // Within Flooring activity range
        activityIds: ['activity_${plotId}_flooring'], // Linked to Flooring activity
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now.subtract(const Duration(days: 6)),
      ),
      ScheduleModel(
        id: '12',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'work',
        title: 'Weeding Work',
        description: 'Remove weeds from the plot',
        scheduledDate: now, // Today - within Flooring activity range
        activityIds: ['activity_${plotId}_flooring'], // Linked to Flooring activity
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      ScheduleModel(
        id: '13',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'work',
        title: 'Harvesting Work',
        description: 'Harvest mature crops',
        scheduledDate: now.subtract(const Duration(days: 3)), // Exactly on Flooring start date
        activityIds: ['activity_${plotId}_flooring'], // Linked to Flooring activity
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      ScheduleModel(
        id: '14',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'work',
        title: 'Soil Preparation',
        description: 'Prepare soil for next season',
        scheduledDate: now.add(const Duration(days: 24)),
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      ScheduleModel(
        id: '15',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'work',
        title: 'Irrigation Setup',
        description: 'Set up irrigation system',
        scheduledDate: now.add(const Duration(days: 30)),
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
      
      // Additional schedules for edge cases (3 more)
      ScheduleModel(
        id: '16',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'spray',
        title: 'Final Pesticide Spray',
        description: 'Final round of pesticide before harvest',
        scheduledDate: now.add(const Duration(days: 35)),
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ),
      ScheduleModel(
        id: '17',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'nutrition',
        title: 'Pre-Harvest Nutrition',
        description: 'Final nutrition application before harvest',
        scheduledDate: now.add(const Duration(days: 40)),
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      ScheduleModel(
        id: '18',
        plotId: plotId,
        plotName: 'Plot A',
        type: 'work',
        title: 'Post-Harvest Cleanup',
        description: 'Clean up after harvest',
        scheduledDate: now.add(const Duration(days: 45)),
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
    ];

    // Filter by type if provided
    var filtered = mockSchedules;
    if (type != null && type != 'all') {
      filtered = mockSchedules.where((s) => s.type == type).toList();
    }

    // Sort by date (ascending)
    filtered.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));

    // Limit if provided
    if (limit != null && limit > 0) {
      filtered = filtered.take(limit).toList();
    }

    return filtered;
  }

  @override
  Future<ScheduleModel> createSchedule(ScheduleModel schedule) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 300));
    return schedule.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<ScheduleModel> updateSchedule(ScheduleModel schedule) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 300));
    return schedule.copyWith(updatedAt: DateTime.now());
  }

  @override
  Future<void> deleteSchedule(String scheduleId) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
