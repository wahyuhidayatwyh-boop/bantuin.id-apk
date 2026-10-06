import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/service_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../data/mock_state.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/primary_button.dart';

class DetailJasaScreen extends StatefulWidget {
  final ServiceModel service;

  const DetailJasaScreen({super.key, required this.service});

  @override
  State<DetailJasaScreen> createState() => _DetailJasaScreenState();
}

class _DetailJasaScreenState extends State<DetailJasaScreen> {
  int _selectedSubServiceIndex = 0;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _showOrderBottomSheet(BuildContext context, NumberFormat currencyFormatter) {
    final subServiceTitle = widget.service.subServices.isNotEmpty
        ? widget.service.subServices[_selectedSubServiceIndex]
        : widget.service.title;

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
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.service.providerAvatar),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pesan Layanan dari',
                          style: AppTypography.bodySmall,
                        ),
                        Text(
                          widget.service.providerName,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paket yang Dipilih:',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subServiceTitle,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimasi Biaya:', style: AppTypography.bodySmall),
                        Text(
                          currencyFormatter.format(widget.service.price),
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Catatan / Brief Kebutuhan (Opsional)',
                style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Tuliskan detail kebutuhan, deadline atau preferensi...',
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Konfirmasi Pesan Jasa',
                width: double.infinity,
                onPressed: () {
                  Navigator.pop(ctx);
                  MockAppState.instance.orderService(
                    service: widget.service,
                    selectedSubService: subServiceTitle,
                    price: widget.service.price,
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
                            'Pesanan Terkirim!',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Penyedia ${widget.service.providerName} telah menerima pesanan Anda. Anda dapat memantau status di tab Aktivitas.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
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

    return ListenableBuilder(
      listenable: MockAppState.instance,
      builder: (context, _) {
        final currentService = MockAppState.instance.services.firstWhere(
          (s) => s.id == widget.service.id,
          orElse: () => widget.service,
        );

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Sliver AppBar with Hero Image
              SliverAppBar(
                expandedHeight: 250,
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
                          currentService.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: currentService.isFavorite ? AppColors.heart : AppColors.textPrimary,
                          size: 20,
                        ),
                        onPressed: () {
                          MockAppState.instance.toggleServiceFavorite(currentService.id);
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        currentService.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: AppColors.primaryLight),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            currentService.category.toUpperCase(),
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Service Details Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        currentService.title,
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Provider Card
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
                              radius: 24,
                              backgroundImage: NetworkImage(currentService.providerAvatar),
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
                                          currentService.providerName,
                                          style: AppTypography.titleSmall.copyWith(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      if (currentService.isVerified) ...[
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.verified_rounded,
                                          size: 15,
                                          color: AppColors.primary,
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    currentService.providerRole,
                                    style: AppTypography.bodySmall.copyWith(fontSize: 11.5),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      RatingWidget(
                                        rating: currentService.rating,
                                        reviewCount: currentService.reviewCount,
                                        size: 11,
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
                                      const SizedBox(width: 2),
                                      Text(
                                        currentService.location,
                                        style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Deskripsi
                      Text(
                        'Deskripsi Layanan',
                        style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentService.description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Portfolio section
                      if (currentService.portfolioImages.isNotEmpty) ...[
                        Text(
                          'Portofolio Hasil Kerja',
                          style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 110,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: currentService.portfolioImages.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, i) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  currentService.portfolioImages[i],
                                  width: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 150,
                                    color: AppColors.primaryLight,
                                    child: const Icon(Icons.image, color: AppColors.primary),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 22),
                      ],

                      // Sub Services Selection
                      if (currentService.subServices.isNotEmpty) ...[
                        Text(
                          'Pilihan Paket / Layanan',
                          style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: List.generate(
                            currentService.subServices.length,
                            (index) {
                              final isSelected = _selectedSubServiceIndex == index;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () {
                                    setState(() {
                                      _selectedSubServiceIndex = index;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primaryLight : Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isSelected ? AppColors.primary : AppColors.border,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                          color: isSelected ? AppColors.primary : AppColors.textMuted,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            currentService.subServices[index],
                                            style: AppTypography.bodyMedium.copyWith(
                                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 22),
                      ],

                      // Reviews List
                      Text(
                        'Ulasan Pelanggan (${currentService.reviews.length})',
                        style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 10),
                      if (currentService.reviews.isEmpty)
                        Text(
                          'Belum ada ulasan tertulis untuk jasa ini.',
                          style: AppTypography.bodySmall,
                        )
                      else
                        ...currentService.reviews.map((r) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundAlt,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.borderLight),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundImage: NetworkImage(r.authorAvatar),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          r.authorName,
                                          style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      RatingWidget(rating: r.rating, showCount: false, size: 10),
                                      const SizedBox(width: 6),
                                      Text(r.date, style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    r.comment,
                                    style: AppTypography.bodyMedium.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            )),

                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Action Bar
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
                      Text(
                        'Biaya Mulai',
                        style: AppTypography.bodySmall.copyWith(fontSize: 10.5),
                      ),
                      Text(
                        currencyFormatter.format(currentService.price),
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
                      text: 'Pesan Jasa',
                      icon: Icons.chat_rounded,
                      onPressed: () => _showOrderBottomSheet(context, currencyFormatter),
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
