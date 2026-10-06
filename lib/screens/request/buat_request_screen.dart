import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../data/mock_state.dart';
import '../../models/help_request_model.dart';
import '../../widgets/primary_button.dart';

class BuatRequestScreen extends StatefulWidget {
  const BuatRequestScreen({super.key});

  @override
  State<BuatRequestScreen> createState() => _BuatRequestScreenState();
}

class _BuatRequestScreenState extends State<BuatRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _locationController = TextEditingController(text: 'Kab. Banyumas');

  String _selectedCategory = 'Titip Belanja';
  DateTime _selectedDeadline = DateTime.now().add(const Duration(hours: 6));
  bool _hasPhotoUploaded = false;
  bool _isLoading = false;

  final List<String> _categories = [
    'Titip Belanja',
    'Antar Barang',
    'Ambil Dokumen',
    'Printing',
    'Pindahan',
    'Desain',
    'Service',
    'Lainnya',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDeadline),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final parsedBudget = int.tryParse(_budgetController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 50000;

    setState(() {
      _isLoading = true;
    });

    // Simulate short submission
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final newRequest = HelpRequestModel(
      id: 'req-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      category: _selectedCategory,
      budget: parsedBudget,
      location: _locationController.text.trim(),
      deadline: 'Hari ini, ${_selectedDeadline.hour.toString().padLeft(2, '0')}:${_selectedDeadline.minute.toString().padLeft(2, '0')} WIB',
      requesterName: MockAppState.instance.currentUser.name,
      requesterRole: 'User Terverifikasi',
      requesterAvatar: MockAppState.instance.currentUser.avatar,
      isVerified: true,
      applicantCount: 0,
      createdAt: 'Baru saja',
      requirements: [
        'Hubungi requseter via chat setelah lamaran diterima',
        'Pengerjaan sesuai deskripsi yang tertera',
      ],
      isMine: true,
    );

    MockAppState.instance.addHelpRequest(newRequest);

    setState(() {
      _isLoading = false;
    });

    // Show Success Dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Request Berhasil Dipublikasikan!',
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Permintaan bantuan Anda telah tayang di Kab. Banyumas. Penolong di sekitar Anda akan segera mengajukan diri.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Selesai & Lihat Permintaan',
              width: double.infinity,
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context); // Back to previous page
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Request Bantuan'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Jelaskan tugas bantuan yang Anda butuhkan secara jelas beserta estimasi budget yang pantas.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primaryDark,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Judul Permintaan
                Text(
                  'Judul Permintaan *',
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Titip Beli Martabak Manis & Antar ke Kos',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Judul permintaan tidak boleh kosong';
                    }
                    if (val.trim().length < 8) {
                      return 'Judul minimal 8 karakter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Kategori Dropdown
                Text(
                  'Kategori Layanan *',
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundAlt,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                      items: _categories.map((c) {
                        return DropdownMenuItem<String>(
                          value: c,
                          child: Text(c, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedCategory = val;
                          });
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Deskripsi Lengkap
                Text(
                  'Deskripsi Pekerjaan *',
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Jelaskan detail barang, alamat lengkap pengambilan & pengantaran, catatan penting...',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Deskripsi tugas tidak boleh kosong';
                    }
                    if (val.trim().length < 15) {
                      return 'Deskripsi minimal 15 karakter agar pelamar mengerti';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Budget & Lokasi Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Budget (Rp) *',
                            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _budgetController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '50000',
                              prefixText: 'Rp ',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Budget wajib diisi';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wilayah / Lokasi *',
                            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              hintText: 'Purwokerto',
                              suffixIcon: Icon(Icons.location_on_rounded, size: 18, color: AppColors.primary),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Lokasi wajib diisi';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Deadline Picker
                Text(
                  'Tenggat Waktu (Deadline) *',
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _pickDeadline,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundAlt,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time_filled_rounded, size: 18, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              '${_selectedDeadline.day}/${_selectedDeadline.month}/${_selectedDeadline.year} - Jam ${_selectedDeadline.hour.toString().padLeft(2, '0')}:${_selectedDeadline.minute.toString().padLeft(2, '0')} WIB',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                            ),
                          ],
                        ),
                        Text('Ubah', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Upload Foto Referensi
                Text(
                  'Upload Foto Referensi (Opsional)',
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      _hasPhotoUploaded = !_hasPhotoUploaded;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_hasPhotoUploaded ? 'Foto referensi ditambahkan!' : 'Foto dihapus.'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _hasPhotoUploaded ? AppColors.primaryLight : AppColors.backgroundAlt,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _hasPhotoUploaded ? AppColors.primary : AppColors.border,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: _hasPhotoUploaded
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                'Foto berhasil dilampirkan (Klik untuk hapus)',
                                style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 28),
                              const SizedBox(height: 6),
                              Text(
                                'Sentuh untuk upload foto struk / barang / dokumen',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 32),

                // Submit Button
                PrimaryButton(
                  text: 'Publikasikan Request',
                  width: double.infinity,
                  isLoading: _isLoading,
                  icon: Icons.rocket_launch_rounded,
                  onPressed: _submitForm,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
