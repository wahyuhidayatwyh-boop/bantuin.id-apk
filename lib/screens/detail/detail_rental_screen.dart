import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/rental_item_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../data/mock_state.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/primary_button.dart';

class DetailRentalScreen extends StatefulWidget {
  final RentalItemModel rental;

  const DetailRentalScreen({super.key, required this.rental});

  @override
  State<DetailRentalScreen> createState() => _DetailRentalScreenState();
}

class _DetailRentalScreenState extends State<DetailRentalScreen> {
  int _currentImageIndex = 0;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 3));

  int get _durationDays {
    final diff = _endDate.difference(_startDate).inDays;
    return diff <= 0 ? 1 : diff;
  }

  int get _subtotal => _durationDays * widget.rental.pricePerDay;
  int get _deposit => widget.rental.deposit;
  int get _total => _subtotal + _deposit;

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _showBookingBottomSheet(BuildContext context, NumberFormat currencyFormatter) {
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
                'Konfirmasi Sewa Barang',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 14),

              // Item summary
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.rental.images.first,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: AppColors.primaryLight),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.rental.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Owner: ${widget.rental.ownerName}',
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Durasi: $_durationDays Hari (${DateFormat('dd MMM').format(_startDate)} - ${DateFormat('dd MMM').format(_endDate)})',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 10),

              // Cost Breakdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Biaya Sewa ($_durationDays hari x ${currencyFormatter.format(widget.rental.pricePerDay)})',
                      style: AppTypography.bodyMedium),
                  Text(currencyFormatter.format(_subtotal),
                      style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Uang Jaminan / Deposit', style: AppTypography.bodyMedium),
                      const SizedBox(width: 4),
                      const Icon(Icons.info_outline, size: 14, color: AppColors.textMuted),
                    ],
                  ),
                  Text(currencyFormatter.format(_deposit),
                      style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '*Deposit dikembalikan 100% setelah barang dikembalikan dalam kondisi baik.',
                style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Pembayaran', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800)),
                  Text(
                    currencyFormatter.format(_total),
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Sewa Sekarang & Simpan',
                width: double.infinity,
                icon: Icons.check_circle_outline_rounded,
                onPressed: () {
                  Navigator.pop(ctx);
                  MockAppState.instance.bookRental(
                    item: widget.rental,
                    startDate: _startDate,
                    endDate: _endDate,
                    durationDays: _durationDays,
                    totalPrice: _total,
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
                            'Pemesanan Sewa Berhasil!',
                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Detail sewa barang telah dicatat ke Aktivitas. Pemilik rental akan menyiapkan serah terima unit.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            text: 'Lihat Aktivitas',
                            width: double.infinity,
                            onPressed: () {
                              Navigator.pop(dialogCtx);
                              MockAppState.instance.setTabIndex(4);
                              Navigator.pop(context);
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

    final dateFormat = DateFormat('dd MMM yyyy');

    return ListenableBuilder(
      listenable: MockAppState.instance,
      builder: (context, _) {
        final currentRental = MockAppState.instance.rentals.firstWhere(
          (r) => r.id == widget.rental.id,
          orElse: () => widget.rental,
        );

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Image Slider AppBar
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      child: IconButton(
                        icon: Icon(
                          currentRental.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: currentRental.isFavorite ? AppColors.heart : AppColors.textPrimary,
                          size: 20,
                        ),
                        onPressed: () {
                          MockAppState.instance.toggleRentalFavorite(currentRental.id);
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        itemCount: currentRental.images.length,
                        onPageChanged: (idx) {
                          setState(() {
                            _currentImageIndex = idx;
                          });
                        },
                        itemBuilder: (context, i) {
                          return Image.network(
                            currentRental.images[i],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: AppColors.primaryLight),
                          );
                        },
                      ),
                      // Image dots indicator
                      if (currentRental.images.length > 1)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              currentRental.images.length,
                              (i) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: _currentImageIndex == i ? 18 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _currentImageIndex == i ? AppColors.primary : Colors.white.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 50,
                        left: 16,
                        child: StatusBadge(status: currentRental.status),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      Text(
                        currentRental.category.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Name
                      Text(
                        currentRental.name,
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Rating & Location
                      Row(
                        children: [
                          RatingWidget(
                            rating: currentRental.rating,
                            reviewCount: currentRental.reviewCount,
                            size: 13,
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 2),
                          Text(currentRental.location, style: AppTypography.bodySmall),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Owner Card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundAlt,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(currentRental.ownerAvatar),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          currentRental.ownerName,
                                          style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      if (currentRental.isOwnerVerified) ...[
                                        const SizedBox(width: 4),
                                        const Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
                                      ],
                                    ],
                                  ),
                                  Text('Pemilik Barang Rental Resmi', style: AppTypography.bodySmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // DATE PICKER UI & LOCAL PRICE CALCULATOR
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pilih Jadwal Sewa',
                                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '$_durationDays Hari Sewa',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Date Selectors
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => _pickDateRange(context),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundAlt,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Tanggal Mulai', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.primary),
                                              const SizedBox(width: 4),
                                              Text(
                                                dateFormat.format(_startDate),
                                                style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => _pickDateRange(context),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundAlt,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Tanggal Selesai', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(Icons.event_available_rounded, size: 12, color: AppColors.primary),
                                              const SizedBox(width: 4),
                                              Text(
                                                dateFormat.format(_endDate),
                                                style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),
                            const Divider(height: 1),
                            const SizedBox(height: 10),

                            // Calculation Breakdown
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Subtotal ($_durationDays x ${currencyFormatter.format(currentRental.pricePerDay)})',
                                    style: AppTypography.bodySmall),
                                Text(currencyFormatter.format(_subtotal),
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Deposit Jaminan', style: AppTypography.bodySmall),
                                Text(currencyFormatter.format(_deposit),
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Estimasi',
                                    style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800)),
                                Text(
                                  currencyFormatter.format(_total),
                                  style: AppTypography.titleSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'Deskripsi Barang',
                        style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentRental.description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Specifications
                      Text(
                        'Spesifikasi Lengkap',
                        style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundAlt,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: currentRental.specifications.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 110,
                                    child: Text(
                                      entry.key,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Bar
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
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total ($_durationDays hari)', style: AppTypography.bodySmall.copyWith(fontSize: 10.5)),
                      Text(
                        currencyFormatter.format(_total),
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Sewa Sekarang',
                      icon: Icons.shopping_bag_outlined,
                      onPressed: () => _showBookingBottomSheet(context, currencyFormatter),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
