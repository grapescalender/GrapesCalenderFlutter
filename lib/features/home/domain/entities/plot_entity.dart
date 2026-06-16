/// Plot entity - Domain layer representation
class PlotEntity {

  const PlotEntity({
    required this.id,
    required this.name,
    required this.area,
    required this.location,
    required this.cropType,
    this.pruningDate,
    this.isRunning = false,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String name;
  final double area;
  final String location;
  final String cropType;
  final DateTime? pruningDate; // Nullable for plots without pruning
  final bool isRunning; // Whether plot is currently running
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Calculate days since pruning
  int get daysSincePruning {
    if (pruningDate == null) return 0;
    final now = DateTime.now();
    final difference = now.difference(pruningDate!);
    return difference.inDays;
  }

  /// Check if plot has pruning date
  bool get hasPruningDate => pruningDate != null;
}
