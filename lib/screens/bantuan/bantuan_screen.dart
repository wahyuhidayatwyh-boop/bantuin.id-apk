import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../data/mock_data.dart';
import '../../data/mock_state.dart';
import '../../models/help_request_model.dart';
import '../../widgets/app_search_bar.dart';
import '../../widgets/help_request_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../detail/detail_bantuan_screen.dart';
import '../request/buat_request_screen.dart';

class BantuanScreen extends StatefulWidget {
  const BantuanScreen({super.key});

  @override
  State<BantuanScreen> createState() => _BantuanScreenState();
}

class _BantuanScreenState extends State<BantuanScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOption = 'Terbaru';

  final List<String> _sortOptions = [
    'Terbaru',
    'Budget Tertinggi',
    'Budget Terendah',
    'Pelamar Terbanyak',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HelpRequestModel> _getFilteredRequests(List<HelpRequestModel> allRequests, String selectedCat) {
    var list = allRequests.where((r) {
      final matchesCategory = selectedCat == 'Semua' || r.category.toLowerCase().contains(selectedCat.toLowerCase());
      final matchesSearch = _searchQuery.isEmpty ||
          r.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.requesterName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    if (_sortOption == 'Budget Tertinggi') {
      list.sort((a, b) => b.budget.compareTo(a.budget));
    } else if (_sortOption == 'Budget Terendah') {
      list.sort((a, b) => a.budget.compareTo(b.budget));
    } else if (_sortOption == 'Pelamar Terbanyak') {
      list.sort((a, b) => b.applicantCount.compareTo(a.applicantCount));
    }

    return list;
  }

  void _openFilterSheet(BuildContext context, String currentCat) {
    FilterBottomSheet.show(
      context,
      title: 'Filter Permintaan Bantuan',
      categories: MockData.helpCategories,
      selectedCategory: currentCat,
      sortOptions: _sortOptions,
      selectedSort: _sortOption,
      onApply: (cat, sort) {
        MockAppState.instance.setHelpCategory(cat);
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
        final selectedCat = state.selectedHelpCategory;
        final filteredList = _getFilteredRequests(state.helpRequests, selectedCat);

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Buat Request', style: TextStyle(fontWeight: FontWeight.w800)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BuatRequestScreen()),
              );
            },
          ),
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
                      hintText: 'Cari tugas bantuan harian...',
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
                        itemCount: MockData.helpCategories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final cat = MockData.helpCategories[i];
                          final isSelected = selectedCat == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                state.setHelpCategory(cat);
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

              // Filter status bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.backgroundAlt,
                child: Row(
                  children: [
                    Text(
                      'Tersedia ${filteredList.length} permintaan bantuan',
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

              // Help Requests List
              Expanded(
                child: filteredList.isEmpty
                    ? EmptyState(
                        title: 'Tidak Ada Permintaan Bantuan',
                        message: 'Belum ada permintaan yang cocok dengan kata kunci atau filter ini.',
                        actionText: 'Reset Filter',
                        onAction: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _sortOption = 'Terbaru';
                          });
                          state.setHelpCategory('Semua');
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
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
              ),
            ],
          ),
        );
      },
    );
  }
}
