/// First plot request/response model for farmer onboarding.
class PlotRegistrationModel {
  const PlotRegistrationModel({
    this.plotName,
    this.area,
    this.variety,
    this.soilType,
    this.rootType,
    this.plantationYear,
    this.latitude,
    this.longitude,
    this.success,
    this.plotId,
  });

  factory PlotRegistrationModel.request({
    required String plotName,
    required double area,
    required String variety,
    String? soilType,
    String? rootType,
    int? plantationYear,
    double? latitude,
    double? longitude,
  }) =>
      PlotRegistrationModel(
        plotName: plotName,
        area: area,
        variety: variety,
        soilType: soilType,
        rootType: rootType,
        plantationYear: plantationYear,
        latitude: latitude,
        longitude: longitude,
      );

  factory PlotRegistrationModel.response({
    required bool success,
    required int plotId,
    String? plotName,
  }) =>
      PlotRegistrationModel(
        success: success,
        plotId: plotId,
        plotName: plotName,
      );

  factory PlotRegistrationModel.fromJson(Map<String, dynamic> json) =>
      PlotRegistrationModel(
        plotName: json['plotName'] as String?,
        area: (json['area'] as num?)?.toDouble(),
        variety: json['variety'] as String?,
        soilType: json['soilType'] as String?,
        rootType: json['rootType'] as String?,
        plantationYear: json['plantationYear'] as int?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        success: json['success'] as bool?,
        plotId: json['plotId'] as int?,
      );

  final String? plotName;
  final double? area;
  final String? variety;
  final String? soilType;
  final String? rootType;
  final int? plantationYear;
  final double? latitude;
  final double? longitude;
  final bool? success;
  final int? plotId;

  Map<String, dynamic> toJson() => {
        if (plotName != null) 'plotName': plotName,
        if (area != null) 'area': area,
        if (variety != null) 'variety': variety,
        if (soilType != null) 'soilType': soilType,
        if (rootType != null) 'rootType': rootType,
        if (plantationYear != null) 'plantationYear': plantationYear,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (success != null) 'success': success,
        if (plotId != null) 'plotId': plotId,
      };
}

class PlotBatchRegistrationModel {
  const PlotBatchRegistrationModel({
    required this.success,
    required this.plots,
  });

  factory PlotBatchRegistrationModel.fromJson(Map<String, dynamic> json) =>
      PlotBatchRegistrationModel(
        success: json['success'] as bool? ?? false,
        plots: ((json['plots'] as List<dynamic>?) ?? [])
            .map((plot) =>
                PlotRegistrationModel.fromJson(plot as Map<String, dynamic>))
            .toList(),
      );

  final bool success;
  final List<PlotRegistrationModel> plots;

  Map<String, dynamic> toJson() => {
        'success': success,
        'plots': plots.map((plot) => plot.toJson()).toList(),
      };
}
