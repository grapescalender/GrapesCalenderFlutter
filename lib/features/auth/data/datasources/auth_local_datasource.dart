import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
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
  Future<void> saveFarmerId(String farmerId);
  Future<String?> getFarmerId();
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> clearIds();
}

/// Implementation of AuthLocalDataSource
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

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
      if (userJson == null) return null;
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
  Future<void> clearIds() async {
    try {
      await secureStorage.delete(key: AppConstants.farmerIdKey);
      await secureStorage.delete(key: AppConstants.userIdKey);
    } catch (e) {
      throw CacheException('Failed to clear ids: ${e.toString()}');
    }
  }
}
