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
    const mockUsers = {
      'admin': _MockAuthUser(
        password: 'password',
        firstName: 'John',
        lastName: 'Doe',
        farmName: 'Green Valley Farm',
      ),
      'nodata': _MockAuthUser(
        password: 'password',
        firstName: 'No',
        lastName: 'Data',
        farmName: 'Empty Test Farm',
      ),
    };

    // Validate credentials
    if (username.isEmpty || password.isEmpty) {
      throw const AuthenticationException('Username and password are required');
    }

    final mockUser = mockUsers[username];

    // Check hardcoded credentials
    if (mockUser == null || password != mockUser.password) {
      throw const AuthenticationException('Invalid username or password');
    }

    // Return mock user
    return UserModel(
      id: '1',
      username: username,
      email: '$username@example.com',
      phoneNumber: '+1234567890',
      firstName: mockUser.firstName,
      lastName: mockUser.lastName,
      farmName: mockUser.farmName,
      address: '123 Farm Road',
      city: 'Farm City',
      state: 'Farm State',
      zipCode: '12345',
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

class _MockAuthUser {
  const _MockAuthUser({
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.farmName,
  });

  final String password;
  final String firstName;
  final String lastName;
  final String farmName;
}
