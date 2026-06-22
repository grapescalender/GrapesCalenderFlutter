/// Season setup request/response model for farmer onboarding.
class SeasonSetupModel {
  const SeasonSetupModel({
    this.seasonYear,
    this.currentCycle,
    this.pruningDate,
    this.success,
    this.seasonId,
    this.dashboardReady,
  });

  factory SeasonSetupModel.request({
    required String seasonYear,
    required String currentCycle,
    required String pruningDate,
  }) =>
      SeasonSetupModel(
        seasonYear: seasonYear,
        currentCycle: currentCycle,
        pruningDate: pruningDate,
      );

  factory SeasonSetupModel.response({
    required bool success,
    required int seasonId,
    required bool dashboardReady,
  }) =>
      SeasonSetupModel(
        success: success,
        seasonId: seasonId,
        dashboardReady: dashboardReady,
      );

  factory SeasonSetupModel.fromJson(Map<String, dynamic> json) =>
      SeasonSetupModel(
        seasonYear: json['seasonYear'] as String?,
        currentCycle: json['currentCycle'] as String?,
        pruningDate: json['pruningDate'] as String?,
        success: json['success'] as bool?,
        seasonId: json['seasonId'] as int?,
        dashboardReady: json['dashboardReady'] as bool?,
      );

  final String? seasonYear;
  final String? currentCycle;
  final String? pruningDate;
  final bool? success;
  final int? seasonId;
  final bool? dashboardReady;

  Map<String, dynamic> toJson() => {
        if (seasonYear != null) 'seasonYear': seasonYear,
        if (currentCycle != null) 'currentCycle': currentCycle,
        if (pruningDate != null) 'pruningDate': pruningDate,
        if (success != null) 'success': success,
        if (seasonId != null) 'seasonId': seasonId,
        if (dashboardReady != null) 'dashboardReady': dashboardReady,
      };
}
