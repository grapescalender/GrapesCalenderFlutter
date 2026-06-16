/// User entity - Domain layer representation
/// This is a pure Dart class without any framework dependencies
class UserEntity {

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    this.farmName = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.zipCode = '',
    this.profileImage = '',
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String farmName;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String profileImage;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get fullName => '$firstName $lastName';
}
