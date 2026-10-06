import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'primary_button.dart';

class FilterBottomSheet extends StatefulWidget {
  final String title;
  final List<String> categories;
  final String selectedCategory;
  final List<String> sortOptions;
  final String selectedSort;
  final Function(String category, String sort) onApply;

  const FilterBottomSheet({
    super.key,
    required this.title,
    required this.categories,
    required this.selectedCategory,
    required this.sortOptions,
    required this.selectedSort,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<String> categories,
    required String selectedCategory,
    required List<String> sortOptions,
    required String selectedSort,
    required Function(String category, String sort) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        title: title,
        categories: categories,
        selectedCategory: selectedCategory,
        sortOptions: sortOptions,
        selectedSort: selectedSort,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _currentCategory;
  late String _currentSort;

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.selectedCategory;
    _currentSort = widget.selectedSort;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
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

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentCategory = widget.categories.first;
                    _currentSort = widget.sortOptions.first;
                  });
                },
                child: Text(
                  'Reset',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Kategori
          Text(
            'Kategori',
            style: AppTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.categories.map((cat) {
              final isSelected = _currentCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (val) {
                  if (val) setState(() => _currentCategory = cat);
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
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Urutkan (Sorting)
          Text(
            'Urutkan Berdasarkan',
            style: AppTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.sortOptions.map((opt) {
              final isSelected = _currentSort == opt;
              return ChoiceChip(
                label: Text(opt),
                selected: isSelected,
                onSelected: (val) {
                  if (val) setState(() => _currentSort = opt);
                },
                selectedColor: AppColors.primaryLight,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
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
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Apply Button
          PrimaryButton(
            text: 'Terapkan Filter',
            width: double.infinity,
            onPressed: () {
              widget.onApply(_currentCategory, _currentSort);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
