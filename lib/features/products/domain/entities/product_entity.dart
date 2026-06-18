/// Product category enum
enum ProductCategory {
  all,
  pesticides,
  insecticides,
  fungicides,
  fertilizers,
  nutrition,
  growthRegulators,
  bioProducts;

  String get displayName {
    switch (this) {
      case ProductCategory.all:
        return 'All';
      case ProductCategory.pesticides:
        return 'Pesticides';
      case ProductCategory.insecticides:
        return 'Insecticides';
      case ProductCategory.fungicides:
        return 'Fungicides';
      case ProductCategory.fertilizers:
        return 'Fertilizers';
      case ProductCategory.nutrition:
        return 'Nutrition';
      case ProductCategory.growthRegulators:
        return 'Growth Regulators';
      case ProductCategory.bioProducts:
        return 'Bio Products';
    }
  }

  String get value {
    switch (this) {
      case ProductCategory.all:
        return 'all';
      case ProductCategory.pesticides:
        return 'pesticides';
      case ProductCategory.insecticides:
        return 'insecticides';
      case ProductCategory.fungicides:
        return 'fungicides';
      case ProductCategory.fertilizers:
        return 'fertilizers';
      case ProductCategory.nutrition:
        return 'nutrition';
      case ProductCategory.growthRegulators:
        return 'growth_regulators';
      case ProductCategory.bioProducts:
        return 'bio_products';
    }
  }

  static ProductCategory fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pesticides':
        return ProductCategory.pesticides;
      case 'insecticides':
        return ProductCategory.insecticides;
      case 'fungicides':
        return ProductCategory.fungicides;
      case 'fertilizers':
        return ProductCategory.fertilizers;
      case 'nutrition':
        return ProductCategory.nutrition;
      case 'growth_regulators':
        return ProductCategory.growthRegulators;
      case 'bio_products':
        return ProductCategory.bioProducts;
      default:
        return ProductCategory.all;
    }
  }
}

/// Product entity — domain layer
class ProductEntity {
  const ProductEntity({
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
  final ProductCategory category;
  final String company;
  final String description;

  /// E.g. ['Berry Setting', 'Flowering', 'Pre-harvest']
  final List<String> recommendedStages;

  /// Dosage instructions, e.g. "2–3 ml/L water"
  final String dosage;

  /// How to apply: "Foliar spray", "Soil drench", etc.
  final String applicationMethod;

  /// Key benefits bullet list
  final List<String> benefits;

  /// Safety / precaution notes
  final List<String> precautions;

  /// Step-by-step usage instructions
  final String usageInstructions;

  /// IDs of related products for cross-linking
  final List<String> relatedProductIds;

  /// Badge: newly added product
  final bool isNew;

  /// Badge: featured / recommended
  final bool isFeatured;

  /// Optional remote image URL (null = use placeholder icon)
  final String? imageUrl;

  /// First recommended stage for compact card display
  String get primaryStage =>
      recommendedStages.isNotEmpty ? recommendedStages.first : '—';
}
