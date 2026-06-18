import '../../domain/entities/product_entity.dart';

/// Product model — data layer. Plain Dart class (no freezed needed; mock only).
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.company,
    required this.description,
    required this.recommendedStages,
    required this.dosage,
    required this.applicationMethod,
    required this.benefits,
    required this.precautions,
    required this.usageInstructions,
    this.relatedProductIds = const [],
    this.isNew = false,
    this.isFeatured = false,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String category; // raw string from API
  final String company;
  final String description;
  final List<String> recommendedStages;
  final String dosage;
  final String applicationMethod;
  final List<String> benefits;
  final List<String> precautions;
  final String usageInstructions;
  final List<String> relatedProductIds;
  final bool isNew;
  final bool isFeatured;
  final String? imageUrl;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        company: json['company'] as String,
        description: json['description'] as String,
        recommendedStages: List<String>.from(json['recommendedStages'] as List),
        dosage: json['dosage'] as String,
        applicationMethod: json['applicationMethod'] as String,
        benefits: List<String>.from(json['benefits'] as List),
        precautions: List<String>.from(json['precautions'] as List),
        usageInstructions: json['usageInstructions'] as String,
        relatedProductIds: json['relatedProductIds'] != null
            ? List<String>.from(json['relatedProductIds'] as List)
            : const [],
        isNew: json['isNew'] as bool? ?? false,
        isFeatured: json['isFeatured'] as bool? ?? false,
        imageUrl: json['imageUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'company': company,
        'description': description,
        'recommendedStages': recommendedStages,
        'dosage': dosage,
        'applicationMethod': applicationMethod,
        'benefits': benefits,
        'precautions': precautions,
        'usageInstructions': usageInstructions,
        'relatedProductIds': relatedProductIds,
        'isNew': isNew,
        'isFeatured': isFeatured,
        'imageUrl': imageUrl,
      };

  /// Convert to domain entity
  ProductEntity toEntity() => ProductEntity(
        id: id,
        name: name,
        category: ProductCategory.fromString(category),
        company: company,
        description: description,
        recommendedStages: recommendedStages,
        dosage: dosage,
        applicationMethod: applicationMethod,
        benefits: benefits,
        precautions: precautions,
        usageInstructions: usageInstructions,
        relatedProductIds: relatedProductIds,
        isNew: isNew,
        isFeatured: isFeatured,
        imageUrl: imageUrl,
      );
}
