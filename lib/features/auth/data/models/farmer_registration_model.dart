/// Mobile OTP request/response model for farmer registration.
class FarmerRegistrationModel {
  const FarmerRegistrationModel({
    this.mobileNumber,
    this.otp,
    this.success,
    this.message,
    this.token,
    this.userId,
    this.isProfileCompleted,
  });

  factory FarmerRegistrationModel.sendOtpRequest({
    required String mobileNumber,
  }) =>
      FarmerRegistrationModel(mobileNumber: mobileNumber);

  factory FarmerRegistrationModel.sendOtpResponse({
    required bool success,
    required String message,
  }) =>
      FarmerRegistrationModel(success: success, message: message);

  factory FarmerRegistrationModel.verifyOtpRequest({
    required String mobileNumber,
    required String otp,
  }) =>
      FarmerRegistrationModel(mobileNumber: mobileNumber, otp: otp);

  factory FarmerRegistrationModel.verifyOtpResponse({
    required bool success,
    required String token,
    required int userId,
    required bool isProfileCompleted,
  }) =>
      FarmerRegistrationModel(
        success: success,
        token: token,
        userId: userId,
        isProfileCompleted: isProfileCompleted,
      );

  factory FarmerRegistrationModel.fromJson(Map<String, dynamic> json) =>
      FarmerRegistrationModel(
        mobileNumber: json['mobileNumber'] as String?,
        otp: json['otp'] as String?,
        success: json['success'] as bool?,
        message: json['message'] as String?,
        token: json['token'] as String?,
        userId: json['userId'] as int?,
        isProfileCompleted: json['isProfileCompleted'] as bool?,
      );

  final String? mobileNumber;
  final String? otp;
  final bool? success;
  final String? message;
  final String? token;
  final int? userId;
  final bool? isProfileCompleted;

  Map<String, dynamic> toJson() => {
        if (mobileNumber != null) 'mobileNumber': mobileNumber,
        if (otp != null) 'otp': otp,
        if (success != null) 'success': success,
        if (message != null) 'message': message,
        if (token != null) 'token': token,
        if (userId != null) 'userId': userId,
        if (isProfileCompleted != null)
          'isProfileCompleted': isProfileCompleted,
      };
}
