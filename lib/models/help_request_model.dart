class HelpRequestModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final int budget;
  final String location;
  final String deadline;
  final String requesterName;
  final String requesterRole;
  final String requesterAvatar;
  final bool isVerified;
  final int applicantCount;
  final String createdAt;
  final List<String> requirements;
  final bool isMine;
  final String status;

  const HelpRequestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.budget,
    required this.location,
    required this.deadline,
    required this.requesterName,
    required this.requesterRole,
    required this.requesterAvatar,
    required this.isVerified,
    required this.applicantCount,
    required this.createdAt,
    required this.requirements,
    this.isMine = false,
    this.status = 'Aktif',
  });

  HelpRequestModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? budget,
    String? location,
    String? deadline,
    String? requesterName,
    String? requesterRole,
    String? requesterAvatar,
    bool? isVerified,
    int? applicantCount,
    String? createdAt,
    List<String>? requirements,
    bool? isMine,
    String? status,
  }) {
    return HelpRequestModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      budget: budget ?? this.budget,
      location: location ?? this.location,
      deadline: deadline ?? this.deadline,
      requesterName: requesterName ?? this.requesterName,
      requesterRole: requesterRole ?? this.requesterRole,
      requesterAvatar: requesterAvatar ?? this.requesterAvatar,
      isVerified: isVerified ?? this.isVerified,
      applicantCount: applicantCount ?? this.applicantCount,
      createdAt: createdAt ?? this.createdAt,
      requirements: requirements ?? this.requirements,
      isMine: isMine ?? this.isMine,
      status: status ?? this.status,
    );
  }
}
