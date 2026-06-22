import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/farmer_onboarding_state.dart';
import '../models/user_model.dart';

/// Local data source for authentication
/// Handles local storage (SharedPreferences, SecureStorage)
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> clearRefreshToken();
  Future<void> saveAuthMobileNumber(String mobileNumber);
  Future<String?> getAuthMobileNumber();
  Future<void> clearAuthMobileNumber();
  Future<void> saveFarmerId(String farmerId);
  Future<String?> getFarmerId();
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> savePlotId(String plotId);
  Future<String?> getPlotId();
  Future<void> saveSeasonId(String seasonId);
  Future<String?> getSeasonId();
  Future<void> saveOnboardingState(FarmerOnboardingState state);
  Future<FarmerOnboardingState> getOnboardingState();
  Future<void> clearIds();
  Future<void> clearSession();
}

/// Implementation of AuthLocalDataSource
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(AppConstants.userKey, userJson);
    } catch (e) {
      throw CacheException('Failed to cache user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(AppConstants.userKey);
      if (userJson == null) {
        return null;
      }
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      throw CacheException('Failed to get cached user: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(AppConstants.userKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await secureStorage.write(
        key: AppConstants.tokenKey,
        value: token,
      );
    } catch (e) {
      throw CacheException('Failed to save token: ${e.toString()}');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await secureStorage.read(key: AppConstants.tokenKey);
    } catch (e) {
      throw CacheException('Failed to get token: ${e.toString()}');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await secureStorage.delete(key: AppConstants.tokenKey);
    } catch (e) {
      throw CacheException('Failed to clear token: ${e.toString()}');
    }
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await secureStorage.write(
        key: AppConstants.refreshTokenKey,
        value: token,
      );
    } catch (e) {
      throw CacheException('Failed to save refresh token: ${e.toString()}');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await secureStorage.read(key: AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to get refresh token: ${e.toString()}');
    }
  }

  @override
  Future<void> clearRefreshToken() async {
    try {
      await secureStorage.delete(key: AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to clear refresh token: ${e.toString()}');
    }
  }

  @override
  Future<void> saveAuthMobileNumber(String mobileNumber) async {
    try {
      await secureStorage.write(
        key: AppConstants.authMobileNumberKey,
        value: mobileNumber,
      );
    } catch (e) {
      throw CacheException(
          'Failed to save auth mobile number: ${e.toString()}');
    }
  }

  @override
  Future<String?> getAuthMobileNumber() async {
    try {
      return await secureStorage.read(key: AppConstants.authMobileNumberKey);
    } catch (e) {
      throw CacheException('Failed to get auth mobile number: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAuthMobileNumber() async {
    try {
      await secureStorage.delete(key: AppConstants.authMobileNumberKey);
    } catch (e) {
      throw CacheException(
          'Failed to clear auth mobile number: ${e.toString()}');
    }
  }

  @override
  Future<void> saveFarmerId(String farmerId) async {
    try {
      await secureStorage.write(
        key: AppConstants.farmerIdKey,
        value: farmerId,
      );
    } catch (e) {
      throw CacheException('Failed to save farmer id: ${e.toString()}');
    }
  }

  @override
  Future<String?> getFarmerId() async {
    try {
      return await secureStorage.read(key: AppConstants.farmerIdKey);
    } catch (e) {
      throw CacheException('Failed to get farmer id: ${e.toString()}');
    }
  }

  @override
  Future<void> saveUserId(String userId) async {
    try {
      await secureStorage.write(
        key: AppConstants.userIdKey,
        value: userId,
      );
    } catch (e) {
      throw CacheException('Failed to save user id: ${e.toString()}');
    }
  }

  @override
  Future<String?> getUserId() async {
    try {
      return await secureStorage.read(key: AppConstants.userIdKey);
    } catch (e) {
      throw CacheException('Failed to get user id: ${e.toString()}');
    }
  }

  @override
  Future<void> savePlotId(String plotId) async {
    try {
      await secureStorage.write(
        key: AppConstants.plotIdKey,
        value: plotId,
      );
    } catch (e) {
      throw CacheException('Failed to save plot id: ${e.toString()}');
    }
  }

  @override
  Future<String?> getPlotId() async {
    try {
      return await secureStorage.read(key: AppConstants.plotIdKey);
    } catch (e) {
      throw CacheException('Failed to get plot id: ${e.toString()}');
    }
  }

  @override
  Future<void> saveSeasonId(String seasonId) async {
    try {
      await secureStorage.write(
        key: AppConstants.seasonIdKey,
        value: seasonId,
      );
    } catch (e) {
      throw CacheException('Failed to save season id: ${e.toString()}');
    }
  }

  @override
  Future<String?> getSeasonId() async {
    try {
      return await secureStorage.read(key: AppConstants.seasonIdKey);
    } catch (e) {
      throw CacheException('Failed to get season id: ${e.toString()}');
    }
  }

  @override
  Future<void> saveOnboardingState(FarmerOnboardingState state) async {
    try {
      await sharedPreferences.setString(
        AppConstants.onboardingStateKey,
        state.storageValue,
      );
    } catch (e) {
      throw CacheException('Failed to save onboarding state: ${e.toString()}');
    }
  }

  @override
  Future<FarmerOnboardingState> getOnboardingState() async {
    try {
      return FarmerOnboardingStateX.fromStorageValue(
        sharedPreferences.getString(AppConstants.onboardingStateKey),
      );
    } catch (e) {
      throw CacheException('Failed to get onboarding state: ${e.toString()}');
    }
  }

  @override
  Future<void> clearIds() async {
    try {
      await secureStorage.delete(key: AppConstants.farmerIdKey);
      await secureStorage.delete(key: AppConstants.userIdKey);
      await secureStorage.delete(key: AppConstants.plotIdKey);
      await secureStorage.delete(key: AppConstants.seasonIdKey);
      await sharedPreferences.remove(AppConstants.onboardingStateKey);
    } catch (e) {
      throw CacheException('Failed to clear ids: ${e.toString()}');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      // Logout must remove only user/session persistence. Theme, language,
      // and non-user app settings are intentionally left untouched.
      await clearCache();
      await clearToken();
      await clearRefreshToken();
      await clearAuthMobileNumber();
      await clearIds();
      await sharedPreferences.remove(AppConstants.tokenKey);
      await sharedPreferences.remove(AppConstants.refreshTokenKey);
      await sharedPreferences.remove(AppConstants.authMobileNumberKey);
      await sharedPreferences.remove(AppConstants.farmerIdKey);
      await sharedPreferences.remove(AppConstants.userIdKey);
      await sharedPreferences.remove(AppConstants.plotIdKey);
      await sharedPreferences.remove(AppConstants.seasonIdKey);
    } catch (e) {
      throw CacheException('Failed to clear session: ${e.toString()}');
    }
  }
}
