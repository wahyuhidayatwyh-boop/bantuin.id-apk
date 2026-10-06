import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/help_request_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../data/mock_state.dart';
import '../../widgets/primary_button.dart';

class DetailBantuanScreen extends StatefulWidget {
  final HelpRequestModel request;

  const DetailBantuanScreen({super.key, required this.request});

  @override
  State<DetailBantuanScreen> createState() => _DetailBantuanScreenState();
}

class _DetailBantuanScreenState extends State<DetailBantuanScreen> {
  final TextEditingController _proposalController = TextEditingController();

  @override
  void dispose() {
    _proposalController.dispose();
    super.dispose();
  }

  void _showApplyBottomSheet(BuildContext context, NumberFormat currencyFormatter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ajukan Diri untuk Membantu',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kirimkan pesan penawaran kepada pembuat request.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Budget yang Diterima:', style: AppTypography.bodySmall),
                        Text(
                          currencyFormatter.format(widget.request.budget),
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '100% Escrow',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pesan / Pengalaman Singkat',
                style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _proposalController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Halo, saya bisa bantu tugas ini sekarang karena lokasi saya dekat...',
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Kirim Lamaran Bantuan',
                width: double.infinity,
                icon: Icons.send_rounded,
                onPressed: () {
                  Navigator.pop(ctx);
                  MockAppState.instance.applyHelp(
                    request: widget.request,
                    message: _proposalController.text,
                  );

                  showDialog(
                    context: context,
                    builder: (dialogCtx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: const EdgeInsets.all(24),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.successLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 36),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Lamaran Terkirim!',
                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pembuat request akan meninjau pesan Anda. Anda akan diberitahu setelah diterima.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            text: 'Lihat Aktivitas',
                            width: double.infinity,
                            onPressed: () {
                              Navigator.pop(dialogCtx);
                              MockAppState.instance.setTabIndex(4); // Aktivitas tab
                              Navigator.pop(context); // back to main
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Bantuan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tautan request disalin ke clipboard')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Chip & Deadline
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.request.category,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.schedule_rounded, size: 14, color: AppColors.warning),
                  const SizedBox(width: 4),
                  Text(
                    'Deadline: ${widget.request.deadline}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Title
              Text(
                widget.request.title,
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 16),

              // Requester Profile Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundAlt,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(widget.request.requesterAvatar),
                      backgroundColor: AppColors.primaryLight,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.request.requesterName,
                                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ),
                              if (widget.request.isVerified) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
                              ],
                              if (widget.request.isMine) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.successLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Milik Saya',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.request.requesterRole,
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
                              const SizedBox(width: 2),
                              Text(widget.request.location, style: AppTypography.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Budget Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tawaran Budget', style: AppTypography.bodySmall.copyWith(color: AppColors.primary)),
                        const SizedBox(height: 2),
                        Text(
                          currencyFormatter.format(widget.request.budget),
                          style: AppTypography.titleLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0F000000), blurRadius: 4),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people_alt_rounded, size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.request.applicantCount} Pelamar',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Description
              Text(
                'Deskripsi Pekerjaan',
                style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                widget.request.description,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 24),

              // Requirements list
              if (widget.request.requirements.isNotEmpty) ...[
                Text(
                  'Kriteria & Ketentuan Tugas',
                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                ...widget.request.requirements.map(
                  (req) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            req,
                            style: AppTypography.bodyMedium.copyWith(height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Escrow protection banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user_rounded, color: AppColors.success, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Pembayaran akan diteruskan kepada Anda begitu pembuat request mengonfirmasi tugas telah selesai.',
                        style: AppTypography.bodySmall.copyWith(
                          color: const Color(0xFF15803D),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: PrimaryButton(
            text: widget.request.isMine ? 'Kelola Permintaan Saya' : 'Bantu Sekarang',
            icon: widget.request.isMine ? Icons.edit_rounded : Icons.handshake_rounded,
            onPressed: () => _showApplyBottomSheet(context, currencyFormatter),
          ),
        ),
      ),
    );
  }
}
