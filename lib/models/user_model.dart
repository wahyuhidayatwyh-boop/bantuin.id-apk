class UserModel {
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String location;
  final String bio;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String joinedDate;
  final int completedHelpCount;
  final int servicesUsedCount;
  final int activeRentalsCount;

  const UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.location,
    this.bio = 'Mahasiswa aktif & freelance enthusiast di Banyumas.',
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.joinedDate,
    required this.completedHelpCount,
    required this.servicesUsedCount,
    required this.activeRentalsCount,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? location,
    String? bio,
    double? rating,
    int? reviewCount,
    bool? isVerified,
    String? joinedDate,
    int? completedHelpCount,
    int? servicesUsedCount,
    int? activeRentalsCount,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isVerified: isVerified ?? this.isVerified,
      joinedDate: joinedDate ?? this.joinedDate,
      completedHelpCount: completedHelpCount ?? this.completedHelpCount,
      servicesUsedCount: servicesUsedCount ?? this.servicesUsedCount,
      activeRentalsCount: activeRentalsCount ?? this.activeRentalsCount,
    );
  }
}
