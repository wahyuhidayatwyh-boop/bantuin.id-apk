import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../data/mock_data.dart';
import '../../data/mock_state.dart';
import '../../models/rental_item_model.dart';
import '../../widgets/app_search_bar.dart';
import '../../widgets/rental_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../detail/detail_rental_screen.dart';

class SewaScreen extends StatefulWidget {
  const SewaScreen({super.key});

  @override
  State<SewaScreen> createState() => _SewaScreenState();
}

class _SewaScreenState extends State<SewaScreen> {
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

  List<RentalItemModel> _getFilteredRentals(List<RentalItemModel> allRentals, String selectedCat) {
    var list = allRentals.where((r) {
      final matchesCategory = selectedCat == 'Semua' || r.category.toLowerCase().contains(selectedCat.toLowerCase());
      final matchesSearch = _searchQuery.isEmpty ||
          r.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.ownerName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    if (_sortOption == 'Harga Terendah') {
      list.sort((a, b) => a.pricePerDay.compareTo(b.pricePerDay));
    } else if (_sortOption == 'Harga Tertinggi') {
      list.sort((a, b) => b.pricePerDay.compareTo(a.pricePerDay));
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
      title: 'Filter Katalog Sewa',
      categories: MockData.rentalCategories,
      selectedCategory: currentCat,
      sortOptions: _sortOptions,
      selectedSort: _sortOption,
      onApply: (cat, sort) {
        MockAppState.instance.setRentalCategory(cat);
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
        final selectedCat = state.selectedRentalCategory;
        final filteredList = _getFilteredRentals(state.rentals, selectedCat);

        return Scaffold(
          body: Column(
            children: [
              // Search & Categories Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Column(
                  children: [
                    AppSearchBar(
                      controller: _searchController,
                      hintText: 'Cari kamera, lensa, drone, mic...',
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
                        itemCount: MockData.rentalCategories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final cat = MockData.rentalCategories[i];
                          final isSelected = selectedCat == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                state.setRentalCategory(cat);
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

              // Filter info row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.backgroundAlt,
                child: Row(
                  children: [
                    Text(
                      'Tersedia ${filteredList.length} barang rental',
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

              // Rental Items List
              Expanded(
                child: filteredList.isEmpty
                    ? EmptyState(
                        title: 'Tidak Ada Barang Rental',
                        message: 'Barang yang Anda cari belum tersedia untuk filter atau kata kunci ini.',
                        actionText: 'Reset Filter',
                        onAction: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _sortOption = 'Rating Tertinggi';
                          });
                          state.setRentalCategory('Semua');
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final rental = filteredList[index];
                          return RentalCard(
                            rental: rental,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailRentalScreen(rental: rental),
                                ),
                              );
                            },
                            onFavoriteTap: () {
                              state.toggleRentalFavorite(rental.id);
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
