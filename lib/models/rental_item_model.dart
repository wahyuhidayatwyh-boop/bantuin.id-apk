class RentalItemModel {
  final String id;
  final String name;
  final String category;
  final int pricePerDay;
  final int deposit;
  final double rating;
  final int reviewCount;
  final String location;
  final String ownerName;
  final String ownerAvatar;
  final bool isOwnerVerified;
  final String status;
  final List<String> images;
  final String description;
  final Map<String, String> specifications;
  final bool isFavorite;

  const RentalItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.pricePerDay,
    required this.deposit,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.ownerName,
    required this.ownerAvatar,
    required this.isOwnerVerified,
    required this.status,
    required this.images,
    required this.description,
    required this.specifications,
    this.isFavorite = false,
  });

  RentalItemModel copyWith({
    String? id,
    String? name,
    String? category,
    int? pricePerDay,
    int? deposit,
    double? rating,
    int? reviewCount,
    String? location,
    String? ownerName,
    String? ownerAvatar,
    bool? isOwnerVerified,
    String? status,
    List<String>? images,
    String? description,
    Map<String, String>? specifications,
    bool? isFavorite,
  }) {
    return RentalItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      deposit: deposit ?? this.deposit,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      location: location ?? this.location,
      ownerName: ownerName ?? this.ownerName,
      ownerAvatar: ownerAvatar ?? this.ownerAvatar,
      isOwnerVerified: isOwnerVerified ?? this.isOwnerVerified,
      status: status ?? this.status,
      images: images ?? this.images,
      description: description ?? this.description,
      specifications: specifications ?? this.specifications,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
