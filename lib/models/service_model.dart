class ServiceReview {
  final String authorName;
  final String authorAvatar;
  final double rating;
  final String date;
  final String comment;

  const ServiceReview({
    required this.authorName,
    required this.authorAvatar,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

class ServiceModel {
  final String id;
  final String title;
  final String providerName;
  final String providerRole;
  final String providerAvatar;
  final bool isVerified;
  final String category;
  final int price;
  final double rating;
  final int reviewCount;
  final String location;
  final String imageUrl;
  final String description;
  final List<String> portfolioImages;
  final List<String> subServices;
  final List<ServiceReview> reviews;
  final bool isFavorite;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.providerName,
    required this.providerRole,
    required this.providerAvatar,
    required this.isVerified,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.imageUrl,
    required this.description,
    required this.portfolioImages,
    required this.subServices,
    required this.reviews,
    this.isFavorite = false,
  });

  ServiceModel copyWith({
    String? id,
    String? title,
    String? providerName,
    String? providerRole,
    String? providerAvatar,
    bool? isVerified,
    String? category,
    int? price,
    double? rating,
    int? reviewCount,
    String? location,
    String? imageUrl,
    String? description,
    List<String>? portfolioImages,
    List<String>? subServices,
    List<ServiceReview>? reviews,
    bool? isFavorite,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      providerName: providerName ?? this.providerName,
      providerRole: providerRole ?? this.providerRole,
      providerAvatar: providerAvatar ?? this.providerAvatar,
      isVerified: isVerified ?? this.isVerified,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      portfolioImages: portfolioImages ?? this.portfolioImages,
      subServices: subServices ?? this.subServices,
      reviews: reviews ?? this.reviews,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
