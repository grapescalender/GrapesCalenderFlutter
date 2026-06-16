/// Plot model representing a vineyard plot
class PlotModel {

  PlotModel({
    required this.id,
    required this.plotName,
    required this.location,
    required this.areaInAcres,
    required this.grapeVariety,
    required this.pruningDate,
    this.isSelected = false,
  });
  final String id;
  final String plotName;
  final String location;
  final double areaInAcres;
  final String grapeVariety;
  final DateTime pruningDate;
  final bool isSelected;

  /// Days since pruning
  int get calculatedDaysFromPruning {
    final now = DateTime.now();
    return now.difference(pruningDate).inDays;
  }

  /// Create a copy with modified fields
  PlotModel copyWith({
    String? id,
    String? plotName,
    String? location,
    double? areaInAcres,
    String? grapeVariety,
    DateTime? pruningDate,
    bool? isSelected,
  }) => PlotModel(
      id: id ?? this.id,
      plotName: plotName ?? this.plotName,
      location: location ?? this.location,
      areaInAcres: areaInAcres ?? this.areaInAcres,
      grapeVariety: grapeVariety ?? this.grapeVariety,
      pruningDate: pruningDate ?? this.pruningDate,
      isSelected: isSelected ?? this.isSelected,
    );

  @override
  String toString() => 'PlotModel(id: $id, plotName: $plotName, location: $location)';
}
