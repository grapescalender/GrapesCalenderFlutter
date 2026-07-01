import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Remote data source for authentication
/// Handles API calls for authentication
abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String username,
    required String password,
  });

  Future<void> logout();

  Future<UserModel> getCurrentUser();

  Future<String> refreshToken();
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Add your API client here (Dio, etc.)
  // final DioClient dioClient;

  // AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    // TODO: Implement actual API call
    // try {
    //   final response = await dioClient.post('/auth/login', data: {
    //     'username': username,
    //     'password': password,
    //   });
    //   return UserModel.fromJson(response.data);
    // } on DioException catch (e) {
    //   throw NetworkException(e.message ?? 'Network error', e.response?.statusCode);
    // }

    // Mock implementation for development
    await Future<void>.delayed(
      const Duration(seconds: 1),
    ); // Simulate network delay

    // Hardcoded credentials for development
    const developmentCredentials = {
      'admin': 'password',
      'nodata': 'password',
    };

    // Validate credentials
    if (username.isEmpty || password.isEmpty) {
      throw const AuthenticationException('Username and password are required');
    }

    final expectedPassword = developmentCredentials[username];

    // Check hardcoded credentials
    if (expectedPassword == null || password != expectedPassword) {
      throw const AuthenticationException('Invalid username or password');
    }

    // Until the real endpoint is connected, keep development authentication
    // data neutral so test identities never leak into customer-facing UI.
    return UserModel(
      id: '1',
      username: '',
      email: '',
      phoneNumber: '',
      firstName: 'Farmer',
      lastName: '',
      farmName: '',
      address: '',
      city: '',
      state: '',
      zipCode: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> logout() async {
    // TODO: Implement logout API call
    await Future<void>.delayed(const Duration(milliseconds: 500));
    // Mock implementation - no error
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // TODO: Implement get current user API call
    throw UnimplementedError('Get current user not implemented');
  }

  @override
  Future<String> refreshToken() async {
    // TODO: Implement refresh token API call
    throw UnimplementedError('Refresh token not implemented');
  }
}
