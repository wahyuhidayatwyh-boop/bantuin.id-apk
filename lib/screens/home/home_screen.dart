import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../data/mock_data.dart';
import '../../data/mock_state.dart';
import '../../widgets/app_search_bar.dart';
import '../../widgets/category_card.dart';
import '../../widgets/help_request_card.dart';
import '../../widgets/service_card.dart';
import '../../widgets/rental_card.dart';
import '../../widgets/section_header.dart';
import '../detail/detail_jasa_screen.dart';
import '../detail/detail_bantuan_screen.dart';
import '../detail/detail_rental_screen.dart';
import '../request/buat_request_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;
    final q = query.toLowerCase();
    if (q.contains('kamera') || q.contains('sewa') || q.contains('drone') || q.contains('lens') || q.contains('mic')) {
      MockAppState.instance.setTabIndex(3); // Sewa
    } else if (q.contains('desain') || q.contains('ac') || q.contains('jasa') || q.contains('web') || q.contains('service')) {
      MockAppState.instance.setTabIndex(1); // Jasa
    } else {
      MockAppState.instance.setTabIndex(2); // Bantuan
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MockAppState.instance,
      builder: (context, _) {
        final state = MockAppState.instance;

        return Scaffold(
          body: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 600));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HERO SECTION with soft gradient & banner
                  _buildHeroSection(context, state),

                  const SizedBox(height: 16),

                  // 4 BENEFIT CARDS
                  _buildBenefitCards(),

                  const SizedBox(height: 20),

                  // CREATE REQUEST BANNER CTA
                  _buildCreateRequestCTA(context),

                  const SizedBox(height: 24),

                  // KATEGORI LAYANAN SECTION
                  _buildCategorySection(context),

                  const SizedBox(height: 24),

                  // PERMINTAAN BANTUAN AKTIF
                  SectionHeader(
                    title: 'Permintaan Bantuan Aktif',
                    subtitle: 'Tugas yang butuh bantuan di ${state.selectedLocation}',
                    actionText: 'Lihat Semua',
                    onAction: () {
                      state.setTabIndex(2); // Go to Bantuan tab
                    },
                  ),
                  const SizedBox(height: 4),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.helpRequests.take(3).length,
                    itemBuilder: (context, index) {
                      final item = state.helpRequests[index];
                      return HelpRequestCard(
                        request: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailBantuanScreen(request: item),
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // REKOMENDASI JASA TERBAIK
                  SectionHeader(
                    title: 'Rekomendasi Jasa',
                    subtitle: 'Penyedia terverifikasi dengan rating tinggi',
                    actionText: 'Lihat Semua',
                    onAction: () {
                      state.setTabIndex(1); // Go to Jasa tab
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 315,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.services.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final item = state.services[index];
                        return ServiceCard(
                          service: item,
                          isHorizontal: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailJasaScreen(service: item),
                              ),
                            );
                          },
                          onFavoriteTap: () {
                            state.toggleServiceFavorite(item.id);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // RENTAL POPULER
                  SectionHeader(
                    title: 'Rental Populer',
                    subtitle: 'Kamera, drone, mic & peralatan event',
                    actionText: 'Lihat Semua',
                    onAction: () {
                      state.setTabIndex(3); // Go to Sewa tab
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 315,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.rentals.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final item = state.rentals[index];
                        return RentalCard(
                          rental: item,
                          isHorizontal: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailRentalScreen(rental: item),
                              ),
                            );
                          },
                          onFavoriteTap: () {
                            state.toggleRentalFavorite(item.id);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // SAFETY & ESCROW PROMO BANNER
                  _buildEscrowBanner(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroSection(BuildContext context, MockAppState state) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.heroGradientStart,
            AppColors.heroGradientMid,
            AppColors.heroGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Location Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white, width: 1),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0A000000), blurRadius: 4),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'BANTUAN, JASA & SEWA DI ${state.selectedLocation.toUpperCase()}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Headline
          RichText(
            text: TextSpan(
              style: AppTypography.displayMedium.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 26,
                letterSpacing: -0.6,
                height: 1.15,
              ),
              children: [
                const TextSpan(text: 'Butuh sesuatu? \n'),
                TextSpan(
                  text: 'Bantuin aja.',
                  style: TextStyle(
                    color: AppColors.primary,
                    shadows: [
                      Shadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Temukan orang yang bisa membantu, jasa terpercaya, atau barang yang bisa kamu sewa di sekitar ${state.selectedLocation} dengan aman & cepat.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 16),

          // Search Bar
          AppSearchBar(
            controller: _searchController,
            hintText: 'Cari jasa, bantuan, sewa kamera...',
            onSubmitted: _onSearchSubmitted,
            showFilterButton: true,
            onFilterTap: () {
              MockAppState.instance.setTabIndex(1);
            },
          ),

          const SizedBox(height: 12),

          // Example Suggestions
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  'Contoh: ',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                ...MockData.searchSuggestions.map((tag) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {
                        _searchController.text = tag;
                        _onSearchSubmitted(tag);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.border, width: 0.8),
                        ),
                        child: Text(
                          tag,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Fast Stats Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('2.4K+', 'Tenaga Bantuan', Icons.people_outline_rounded),
                Container(height: 24, width: 1, color: AppColors.border),
                _buildStatItem('< 15 Menit', 'Respon Cepat', Icons.flash_on_rounded),
                Container(height: 24, width: 1, color: AppColors.border),
                _buildStatItem('100% Aman', 'Rekber Resmi', Icons.verified_user_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String val, String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              val,
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                fontSize: 11,
              ),
            ),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 9.5,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 68,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: MockData.platformBenefits.length,
        itemBuilder: (context, i) {
          final b = MockData.platformBenefits[i];
          IconData icon;
          Color color;
          switch (b['type']) {
            case 'shield':
              icon = Icons.verified_user_rounded;
              color = AppColors.success;
              break;
            case 'location':
              icon = Icons.location_on_rounded;
              color = AppColors.primary;
              break;
            case 'check':
              icon = Icons.check_circle_rounded;
              color = const Color(0xFF6366F1);
              break;
            default:
              icon = Icons.credit_card_rounded;
              color = const Color(0xFFA855F7);
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        b['title']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        b['subtitle']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 9.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreateRequestCTA(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1683FF), Color(0xFF0F6FE5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppColors.buttonShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'PUNYA TUGAS MENDESAK?',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 9.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Buat Request Bantuan Sekarang',
                    style: AppTypography.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tentukan budget sendiri & pelamar langsung merespon.',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BuatRequestScreen()),
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, size: 16),
                  SizedBox(width: 4),
                  Text('Buat', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'KATEGORI LAYANAN',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisExtent: 105,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: MockData.categories.length,
            itemBuilder: (context, i) {
              final cat = MockData.categories[i];
              IconData icon;
              switch (cat['icon']) {
                case 'zap':
                  icon = Icons.bolt_rounded;
                  break;
                case 'camera':
                  icon = Icons.camera_alt_rounded;
                  break;
                case 'palette':
                  icon = Icons.palette_rounded;
                  break;
                case 'package':
                  icon = Icons.inventory_2_rounded;
                  break;
                case 'wrench':
                  icon = Icons.build_rounded;
                  break;
                case 'shopping_cart':
                  icon = Icons.shopping_bag_rounded;
                  break;
                case 'printer':
                  icon = Icons.print_rounded;
                  break;
                default:
                  icon = Icons.cleaning_services_rounded;
              }

              return CategoryCard(
                title: cat['name'],
                icon: icon,
                isCompact: true,
                onTap: () {
                  final tabIndex = cat['tabIndex'] as int;
                  final routeCat = cat['routeCategory'] as String;
                  if (tabIndex == 1) {
                    MockAppState.instance.setServiceCategory(routeCat);
                  } else if (tabIndex == 2) {
                    MockAppState.instance.setHelpCategory(routeCat);
                  } else if (tabIndex == 3) {
                    MockAppState.instance.setRentalCategory(routeCat);
                  }
                  MockAppState.instance.setTabIndex(tabIndex);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEscrowBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFBBF7D0), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: AppColors.success,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sistem Rekening Bersama (Escrow)',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF14532D),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Dana Anda aman di Bantuin sampai pekerjaan selesai diverifikasi kedua belah pihak.',
                    style: AppTypography.bodySmall.copyWith(
                      color: const Color(0xFF15803D),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
