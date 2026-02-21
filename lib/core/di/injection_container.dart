import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';

/// Core providers that are used across the application
/// These are initialized at app startup

/// SharedPreferences provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// FlutterSecureStorage provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Connectivity provider
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// NetworkInfo provider
final networkInfoProvider = FutureProvider<NetworkInfo>((ref) async {
  final connectivity = ref.watch(connectivityProvider);
  return NetworkInfoImpl(connectivity);
});

/// Dio client provider
final dioClientProvider = Provider<DioClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final client = DioClient(secureStorage: secureStorage);
  client.init(); // Initialize Dio with interceptors
  return client;
});

/// Isar database provider (for local storage)
/// Note: Initialize Isar instance in main.dart before using
final isarProvider = FutureProvider<Isar?>((ref) async {
  // Isar instance should be initialized in main.dart
  // This is a placeholder - actual implementation depends on your Isar setup
  return null;
});

/// Router provider - using GoRouter directly
/// Note: appRouter is defined in config/router/app_router.dart
