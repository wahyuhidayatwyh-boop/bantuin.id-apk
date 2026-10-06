class ActivityModel {
  final String id;
  final String type; // 'Request', 'Lamaran', 'Pesanan', 'Rental'
  final String title;
  final String partnerName;
  final String partnerAvatar;
  final int amount;
  final String status; // 'Menunggu', 'Berlangsung', 'Selesai', 'Dibatalkan'
  final String date;
  final String notes;

  const ActivityModel({
    required this.id,
    required this.type,
    required this.title,
    required this.partnerName,
    required this.partnerAvatar,
    required this.amount,
    required this.status,
    required this.date,
    this.notes = '',
  });
}
