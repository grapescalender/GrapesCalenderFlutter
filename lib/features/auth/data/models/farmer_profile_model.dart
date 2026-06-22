/// Farmer basic profile request/response model.
class FarmerProfileModel {
  const FarmerProfileModel({
    this.userId,
    this.farmerName,
    this.village,
    this.taluka,
    this.district,
    this.preferredLanguage,
    this.success,
    this.farmerId,
  });

  factory FarmerProfileModel.request({
    required int userId,
    required String farmerName,
    required String village,
    required String taluka,
    required String district,
    required String preferredLanguage,
  }) =>
      FarmerProfileModel(
        userId: userId,
        farmerName: farmerName,
        village: village,
        taluka: taluka,
        district: district,
        preferredLanguage: preferredLanguage,
      );

  factory FarmerProfileModel.response({
    required bool success,
    required int farmerId,
  }) =>
      FarmerProfileModel(success: success, farmerId: farmerId);

  factory FarmerProfileModel.fromJson(Map<String, dynamic> json) =>
      FarmerProfileModel(
        userId: json['userId'] as int?,
        farmerName: json['farmerName'] as String?,
        village: json['village'] as String?,
        taluka: json['taluka'] as String?,
        district: json['district'] as String?,
        preferredLanguage: json['preferredLanguage'] as String?,
        success: json['success'] as bool?,
        farmerId: json['farmerId'] as int?,
      );

  final int? userId;
  final String? farmerName;
  final String? village;
  final String? taluka;
  final String? district;
  final String? preferredLanguage;
  final bool? success;
  final int? farmerId;

  Map<String, dynamic> toJson() => {
        if (userId != null) 'userId': userId,
        if (farmerName != null) 'farmerName': farmerName,
        if (village != null) 'village': village,
        if (taluka != null) 'taluka': taluka,
        if (district != null) 'district': district,
        if (preferredLanguage != null) 'preferredLanguage': preferredLanguage,
        if (success != null) 'success': success,
        if (farmerId != null) 'farmerId': farmerId,
      };
}
