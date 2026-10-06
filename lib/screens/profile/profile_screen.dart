import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../data/mock_state.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';
import '../detail/detail_jasa_screen.dart';
import '../detail/detail_rental_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Settings toggles
  bool _notificationOrder = true;
  bool _notificationChat = true;
  bool _autoGpsLocation = true;
  String _selectedLanguage = 'Bahasa Indonesia';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MockAppState.instance,
      builder: (context, _) {
        final state = MockAppState.instance;
        final user = state.currentUser;
        final favServices = state.services.where((s) => s.isFavorite).toList();
        final favRentals = state.rentals.where((r) => r.isFavorite).toList();
        final totalFavs = favServices.length + favRentals.length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Pengguna'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => _showSettingsBottomSheet(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.heroGradientStart,
                        AppColors.heroGradientMid,
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: Image.network(
                                  user.avatar,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 44, color: AppColors.primary),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            user.location,
                            style: AppTypography.bodySmall.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
                            const SizedBox(width: 4),
                            Text(
                              '${user.rating} (${user.reviewCount} Ulasan Positif)',
                              style: AppTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (user.bio.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            user.bio,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11.5,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.edit_outlined, size: 15),
                        label: const Text('Edit Profil', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary, width: 1.2),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Statistics Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildStatBox('14', 'Bantuan Selesai', Icons.volunteer_activism_rounded),
                      const SizedBox(width: 10),
                      _buildStatBox('8', 'Jasa Digunakan', Icons.business_center_rounded),
                      const SizedBox(width: 10),
                      _buildStatBox('3', 'Rental Aktif', Icons.storefront_rounded),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Menu Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.person_outline_rounded,
                        title: 'Edit Profil',
                        subtitle: 'Ubah foto, nama, no HP & bio',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _buildMenuItem(
                        icon: Icons.assignment_outlined,
                        title: 'Request Saya',
                        subtitle: 'Daftar bantuan yang Anda buat',
                        onTap: () {
                          MockAppState.instance.setTabIndex(4); // go to activities
                          Navigator.pop(context);
                        },
                      ),
                      const Divider(height: 1),
                      _buildMenuItem(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Pesanan Saya',
                        subtitle: 'Status jasa & sewa aktif',
                        onTap: () {
                          MockAppState.instance.setTabIndex(4);
                          Navigator.pop(context);
                        },
                      ),
                      const Divider(height: 1),
                      _buildMenuItem(
                        icon: Icons.favorite_border_rounded,
                        title: 'Favorit Saya',
                        subtitle: '$totalFavs item disimpan',
                        badgeText: '$totalFavs',
                        onTap: () => _showFavoritesBottomSheet(context, favServices, favRentals),
                      ),
                      const Divider(height: 1),
                      _buildMenuItem(
                        icon: Icons.history_rounded,
                        title: 'Riwayat Transaksi',
                        subtitle: 'Histori transaksi rekening bersama',
                        onTap: () => _showTransactionHistoryBottomSheet(context),
                      ),
                      const Divider(height: 1),
                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Pengaturan Akun',
                        subtitle: 'Notifikasi, bahasa & privasi',
                        onTap: () => _showSettingsBottomSheet(context),
                      ),
                      const Divider(height: 1),
                      _buildMenuItem(
                        icon: Icons.help_outline_rounded,
                        title: 'Pusat Bantuan & FAQ',
                        subtitle: 'Pertanyaan umum seputar Bantuin',
                        onTap: () => _showHelpFaqBottomSheet(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.danger, width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: const Text('Keluar dari Akun?'),
                            content: const Text('Anda akan keluar dari sesi simulasi aplikasi Bantuin.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Berhasil keluar')),
                                  );
                                },
                                child: const Text('Keluar', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout_rounded, color: AppColors.danger, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Keluar Akun',
                            style: AppTypography.labelLarge.copyWith(color: AppColors.danger),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatBox(String val, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 6),
            Text(
              val,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    String? badgeText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
      title: Text(
        title,
        style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800, fontSize: 13.5),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(fontSize: 11),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeText != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                badgeText,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }

  // 1. Riwayat Transaksi Bottom Sheet
  void _showTransactionHistoryBottomSheet(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final transactions = [
      {
        'id': 'TRX-20261005-01',
        'title': 'Desain Feed Instagram & Banner Promo Toko',
        'amount': 150000,
        'date': '05 Okt 2026, 14:30 WIB',
        'status': 'Selesai',
        'type': 'Bantuan',
      },
      {
        'id': 'TRX-20261004-02',
        'title': 'Sewa Sony Alpha A7 III + Kit Lens (3 Hari)',
        'amount': 350000,
        'date': '04 Okt 2026, 09:15 WIB',
        'status': 'Berlangsung',
        'type': 'Rental',
      },
      {
        'id': 'TRX-20260928-03',
        'title': 'Jasa Service & Cuci AC Rumah Kosan',
        'amount': 65000,
        'date': '28 Sep 2026, 16:40 WIB',
        'status': 'Selesai',
        'type': 'Pesanan',
      },
      {
        'id': 'TRX-20260925-04',
        'title': 'Sewa Wireless Mic DJI Mic 2',
        'amount': 135000,
        'date': '25 Sep 2026, 11:20 WIB',
        'status': 'Dibatalkan',
        'type': 'Rental',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Riwayat Transaksi',
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_rounded, size: 12, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text('100% Escrow', style: AppTypography.labelSmall.copyWith(color: AppColors.success)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final tx = transactions[i];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundAlt,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                tx['id'] as String,
                                style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10),
                              ),
                              const Spacer(),
                              StatusBadge(status: tx['status'] as String, isSmall: true),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tx['title'] as String,
                            style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(tx['date'] as String, style: AppTypography.bodySmall.copyWith(fontSize: 10.5)),
                              Text(
                                currencyFormatter.format(tx['amount']),
                                style: AppTypography.titleSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. Pengaturan Akun Bottom Sheet
  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.all(20),
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
                    'Pengaturan Akun & Aplikasi',
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Notifikasi Pesanan & Bantuan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    subtitle: const Text('Terima pembaruan status lamaran dan pesanan', style: TextStyle(fontSize: 12)),
                    activeColor: AppColors.primary,
                    value: _notificationOrder,
                    onChanged: (val) {
                      setSheetState(() => _notificationOrder = val);
                      setState(() => _notificationOrder = val);
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Notifikasi Obrolan / Chat', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    subtitle: const Text('Terima pesan baru dari requester atau provider', style: TextStyle(fontSize: 12)),
                    activeColor: AppColors.primary,
                    value: _notificationChat,
                    onChanged: (val) {
                      setSheetState(() => _notificationChat = val);
                      setState(() => _notificationChat = val);
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Sinkronisasi Lokasi GPS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    subtitle: const Text('Otomatis filter tugas terdekat berdasarkan GPS', style: TextStyle(fontSize: 12)),
                    activeColor: AppColors.primary,
                    value: _autoGpsLocation,
                    onChanged: (val) {
                      setSheetState(() => _autoGpsLocation = val);
                      setState(() => _autoGpsLocation = val);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Bahasa Aplikasi', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    subtitle: Text(_selectedLanguage, style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                    trailing: const Icon(Icons.language_rounded, color: AppColors.primary),
                    onTap: () {
                      setSheetState(() {
                        _selectedLanguage = _selectedLanguage == 'Bahasa Indonesia' ? 'English' : 'Bahasa Indonesia';
                      });
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: 'Tutup Pengaturan',
                    width: double.infinity,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 4. Pusat Bantuan FAQ Bottom Sheet
  void _showHelpFaqBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
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
                'Pusat Bantuan & FAQ',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w900, fontSize: 18),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: const [
                    ExpansionTile(
                      initiallyExpanded: true,
                      title: Text('Bagaimana cara kerja Rekening Bersama (Escrow)?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Text(
                            'Saat Anda memesan jasa atau sewa, pembayaran Anda ditampung sementara di rekening bersama Bantuin. Dana baru diteruskan ke penyedia setelah pekerjaan diverifikasi selesai oleh Anda.',
                            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text('Bagaimana jika barang rental rusak atau hilang?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Text(
                            'Setiap rental dilindungi oleh deposit jaminan dan perjanjian serah terima unit fisik. Kerusakan ditanggung dari deposit atau penggantian part resmi.',
                            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text('Berapa lama pencairan dana setelah tugas selesai?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Text(
                            'Pencairan dana langsung otomatis masuk ke saldo rekening Anda maksimal 1x24 jam setelah kedua pihak melakukan konfirmasi tugas selesai.',
                            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 5. Favorit Bottom Sheet
  void _showFavoritesBottomSheet(BuildContext context, List favServices, List favRentals) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
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
                'Favorit Saya (${favServices.length + favRentals.length})',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w900, fontSize: 18),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: [
                    if (favServices.isNotEmpty) ...[
                      Text('Jasa Favorit', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      ...favServices.map((s) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(s.imageUrl, width: 48, height: 48, fit: BoxFit.cover),
                            ),
                            title: Text(s.title, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            subtitle: Text('Rp ${s.price}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
                            onTap: () {
                              Navigator.pop(ctx);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => DetailJasaScreen(service: s)));
                            },
                          )),
                      const SizedBox(height: 16),
                    ],
                    if (favRentals.isNotEmpty) ...[
                      Text('Rental Favorit', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      ...favRentals.map((r) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(r.images.first, width: 48, height: 48, fit: BoxFit.cover),
                            ),
                            title: Text(r.name, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            subtitle: Text('Rp ${r.pricePerDay} / hari', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
                            onTap: () {
                              Navigator.pop(ctx);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => DetailRentalScreen(rental: r)));
                            },
                          )),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
