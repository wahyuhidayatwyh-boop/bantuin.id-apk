import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../data/mock_data.dart';
import '../../data/mock_state.dart';
import '../../models/service_model.dart';
import '../../widgets/app_search_bar.dart';
import '../../widgets/service_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../detail/detail_jasa_screen.dart';

class JasaScreen extends StatefulWidget {
  const JasaScreen({super.key});

  @override
  State<JasaScreen> createState() => _JasaScreenState();
}

class _JasaScreenState extends State<JasaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOption = 'Rating Tertinggi';

  final List<String> _sortOptions = [
    'Rating Tertinggi',
    'Harga Terendah',
    'Harga Tertinggi',
    'Ulasan Terbanyak',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceModel> _getFilteredServices(List<ServiceModel> allServices, String selectedCat) {
    var list = allServices.where((s) {
      final matchesCategory = selectedCat == 'Semua' || s.category.toLowerCase().contains(selectedCat.toLowerCase());
      final matchesSearch = _searchQuery.isEmpty ||
          s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.providerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    if (_sortOption == 'Harga Terendah') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortOption == 'Harga Tertinggi') {
      list.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortOption == 'Ulasan Terbanyak') {
      list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    } else {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return list;
  }

  void _openFilterSheet(BuildContext context, String currentCat) {
    FilterBottomSheet.show(
      context,
      title: 'Filter & Urutkan Jasa',
      categories: MockData.serviceCategories,
      selectedCategory: currentCat,
      sortOptions: _sortOptions,
      selectedSort: _sortOption,
      onApply: (cat, sort) {
        MockAppState.instance.setServiceCategory(cat);
        setState(() {
          _sortOption = sort;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MockAppState.instance,
      builder: (context, _) {
        final state = MockAppState.instance;
        final selectedCat = state.selectedServiceCategory;
        final filteredList = _getFilteredServices(state.services, selectedCat);

        return Scaffold(
          body: Column(
            children: [
              // Search & Filter Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Column(
                  children: [
                    AppSearchBar(
                      controller: _searchController,
                      hintText: 'Cari jasa desain, AC, web...',
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim();
                        });
                      },
                      showFilterButton: true,
                      onFilterTap: () => _openFilterSheet(context, selectedCat),
                    ),
                    const SizedBox(height: 12),

                    // Horizontal Category Chips
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: MockData.serviceCategories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final cat = MockData.serviceCategories[i];
                          final isSelected = selectedCat == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                state.setServiceCategory(cat);
                              }
                            },
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.backgroundAlt,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.border,
                              ),
                            ),
                            showCheckmark: false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Filter summary bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.backgroundAlt,
                child: Row(
                  children: [
                    Text(
                      'Menampilkan ${filteredList.length} jasa',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => _openFilterSheet(context, selectedCat),
                      child: Row(
                        children: [
                          const Icon(Icons.sort_rounded, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            _sortOption,
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
              ),

              // Service Cards List
              Expanded(
                child: filteredList.isEmpty
                    ? EmptyState(
                        title: 'Tidak Ada Jasa Ditemukan',
                        message: 'Coba ubah kata kunci pencarian atau reset filter kategori yang dipilih.',
                        actionText: 'Reset Filter',
                        onAction: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _sortOption = 'Rating Tertinggi';
                          });
                          state.setServiceCategory('Semua');
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final service = filteredList[index];
                          return ServiceCard(
                            service: service,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailJasaScreen(service: service),
                                ),
                              );
                            },
                            onFavoriteTap: () {
                              state.toggleServiceFavorite(service.id);
                            },
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
}
