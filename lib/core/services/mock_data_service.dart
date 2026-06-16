// Simple model classes (without Freezed to avoid build_runner issues)
class PlotModel {

  PlotModel({
    required this.id,
    required this.plotName,
    required this.location,
    required this.areaInAcres,
    required this.grapeVariety,
    required this.pruningDate,
  });
  final String id;
  final String plotName;
  final String location;
  final double areaInAcres;
  final String grapeVariety;
  final DateTime pruningDate;

  int get calculatedDaysFromPruning => DateTime.now().difference(pruningDate).inDays;
}

class MockScheduleModel {

  MockScheduleModel({
    required this.id,
    required this.plotId,
    required this.title,
    required this.description,
    required this.scheduledDate,
    required this.type,
    required this.notes,
    required this.isCompleted,
  });
  final String id;
  final String plotId;
  final String title;
  final String description;
  final DateTime scheduledDate;
  final String type;
  final String notes;
  final bool isCompleted;
}

class MockData {
  static final List<PlotModel> mockPlots = [
    PlotModel(
      id: 'plot_1',
      plotName: 'Plot A',
      location: 'Nashik',
      areaInAcres: 2.5,
      grapeVariety: 'Thompson Seedless',
      pruningDate: DateTime.now().subtract(const Duration(days: 19)),
    ),
    PlotModel(
      id: 'plot_2',
      plotName: 'Plot B',
      location: 'Nashik',
      areaInAcres: 3,
      grapeVariety: 'Flame Seedless',
      pruningDate: DateTime.now().subtract(const Duration(days: 13)),
    ),
    PlotModel(
      id: 'plot_3',
      plotName: 'Plot C',
      location: 'Nashik',
      areaInAcres: 2,
      grapeVariety: 'Crimson Seedless',
      pruningDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    PlotModel(
      id: 'plot_4',
      plotName: 'Plot D',
      location: 'Aurangabad',
      areaInAcres: 1.8,
      grapeVariety: 'Red Globe',
      pruningDate: DateTime.now().subtract(const Duration(days: 25)),
    ),
    PlotModel(
      id: 'plot_5',
      plotName: 'Plot E',
      location: 'Aurangabad',
      areaInAcres: 2.2,
      grapeVariety: 'Thompson Seedless',
      pruningDate: DateTime.now().subtract(const Duration(days: 8)),
    ),
    PlotModel(
      id: 'plot_6',
      plotName: 'Plot F',
      location: 'Pune',
      areaInAcres: 1.5,
      grapeVariety: 'Black Beauty',
      pruningDate: DateTime.now().subtract(const Duration(days: 32)),
    ),
    PlotModel(
      id: 'plot_7',
      plotName: 'Plot G',
      location: 'Pune',
      areaInAcres: 2.8,
      grapeVariety: 'Arkavati',
      pruningDate: DateTime.now().subtract(const Duration(days: 12)),
    ),
    PlotModel(
      id: 'plot_8',
      plotName: 'Plot H',
      location: 'Nashik',
      areaInAcres: 3.2,
      grapeVariety: 'Sugraone',
      pruningDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static final List<MockScheduleModel> mockSchedules = [
    // Plot A schedules
    MockScheduleModel(
      id: 'sch_1',
      plotId: 'plot_1',
      title: 'Spray Pesticide',
      description: 'Apply organic pesticide spray',
      scheduledDate: DateTime.now().add(const Duration(days: 2)),
      type: 'spray',
      notes: 'Use neem oil solution',
      isCompleted: false,
    ),
    MockScheduleModel(
      id: 'sch_2',
      plotId: 'plot_1',
      title: 'Nutrient Application',
      description: 'Apply NPK fertilizer',
      scheduledDate: DateTime.now().add(const Duration(days: 5)),
      type: 'nutrition',
      notes: '10:52:10 formulation',
      isCompleted: false,
    ),
    MockScheduleModel(
      id: 'sch_3',
      plotId: 'plot_1',
      title: 'Remove Dead Branches',
      description: 'Prune dead and weak branches',
      scheduledDate: DateTime.now().add(const Duration(days: 7)),
      type: 'work',
      notes: 'Use sterile pruning tools',
      isCompleted: false,
    ),
    MockScheduleModel(
      id: 'sch_4',
      plotId: 'plot_1',
      title: 'Spray Fungicide',
      description: 'Apply fungicide for mildew prevention',
      scheduledDate: DateTime.now().add(const Duration(days: 10)),
      type: 'spray',
      notes: 'Spray during early morning',
      isCompleted: false,
    ),
    MockScheduleModel(
      id: 'sch_5',
      plotId: 'plot_1',
      title: 'Micro Nutrients',
      description: 'Apply boron and zinc supplements',
      scheduledDate: DateTime.now().add(const Duration(days: 12)),
      type: 'nutrition',
      notes: 'Foliar spray recommended',
      isCompleted: true,
    ),
    // Plot B schedules
    MockScheduleModel(
      id: 'sch_6',
      plotId: 'plot_2',
      title: 'Irrigation Check',
      description: 'Monitor soil moisture',
      scheduledDate: DateTime.now().add(const Duration(days: 1)),
      type: 'work',
      notes: 'Soil moisture should be 60-70%',
      isCompleted: false,
    ),
    MockScheduleModel(
      id: 'sch_7',
      plotId: 'plot_2',
      title: 'Leaf Spotting Check',
      description: 'Inspect for fungal diseases',
      scheduledDate: DateTime.now().add(const Duration(days: 3)),
      type: 'spray',
      notes: 'Look for brown spots',
      isCompleted: false,
    ),
    MockScheduleModel(
      id: 'sch_8',
      plotId: 'plot_2',
      title: 'Potassium Boost',
      description: 'Apply potassium-rich fertilizer',
      scheduledDate: DateTime.now().add(const Duration(days: 6)),
      type: 'nutrition',
      notes: 'Important for berry size',
      isCompleted: false,
    ),
    MockScheduleModel(
      id: 'sch_9',
      plotId: 'plot_2',
      title: 'Cluster Thinning',
      description: 'Remove smaller grape clusters',
      scheduledDate: DateTime.now().add(const Duration(days: 8)),
      type: 'work',
      notes: 'Keep strong clusters only',
      isCompleted: false,
    ),
    // Plot C schedules
    MockScheduleModel(
      id: 'sch_10',
      plotId: 'plot_3',
      title: 'Spray Weedicide',
      description: 'Control weed growth',
      scheduledDate: DateTime.now().add(const Duration(days: 4)),
      type: 'spray',
      notes: 'Target inter-row weeds',
      isCompleted: false,
    ),
    MockScheduleModel(
      id: 'sch_11',
      plotId: 'plot_3',
      title: 'Canopy Management',
      description: 'Thin excessive leaves',
      scheduledDate: DateTime.now().add(const Duration(days: 9)),
      type: 'work',
      notes: 'Allow 60-70% light penetration',
      isCompleted: false,
    ),
    MockScheduleModel(
      id: 'sch_12',
      plotId: 'plot_3',
      title: 'Calcium Treatment',
      description: 'Apply calcium for split berry prevention',
      scheduledDate: DateTime.now().add(const Duration(days: 11)),
      type: 'nutrition',
      notes: 'Prevent splitting during ripening',
      isCompleted: false,
    ),
    // Mixed plots for more data
    MockScheduleModel(
      id: 'sch_13',
      plotId: 'plot_4',
      title: 'Pest Monitoring',
      description: 'Check for mealybug infestation',
      scheduledDate: DateTime.now().add(const Duration(days: 2)),
      type: 'work',
      notes: 'Use yellow sticky traps',
      isCompleted: true,
    ),
    MockScheduleModel(
      id: 'sch_14',
      plotId: 'plot_5',
      title: 'Dormant Spray',
      description: 'Apply dormant oil spray',
      scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
      type: 'spray',
      notes: 'For scale and mite control',
      isCompleted: true,
    ),
    MockScheduleModel(
      id: 'sch_15',
      plotId: 'plot_6',
      title: 'Training Pruning',
      description: 'Shape vines for next season',
      scheduledDate: DateTime.now().add(const Duration(days: 15)),
      type: 'work',
      notes: 'Follow umbrella training system',
      isCompleted: false,
    ),
  ];
}
