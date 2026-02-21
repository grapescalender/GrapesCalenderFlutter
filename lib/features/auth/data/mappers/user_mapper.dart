import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

/// Mapper to convert between UserModel (data layer) and UserEntity (domain layer)
class UserMapper {
  /// Convert UserModel to UserEntity
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      username: model.username,
      email: model.email,
      phoneNumber: model.phoneNumber,
      firstName: model.firstName,
      lastName: model.lastName,
      farmName: model.farmName,
      address: model.address,
      city: model.city,
      state: model.state,
      zipCode: model.zipCode,
      profileImage: model.profileImage,
      isActive: model.isActive,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert UserEntity to UserModel
  static UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      firstName: entity.firstName,
      lastName: entity.lastName,
      farmName: entity.farmName,
      address: entity.address,
      city: entity.city,
      state: entity.state,
      zipCode: entity.zipCode,
      profileImage: entity.profileImage,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
