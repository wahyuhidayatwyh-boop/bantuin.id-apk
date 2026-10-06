import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterTap;
  final bool showFilterButton;
  final bool autoFocus;

  const AppSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Kamu lagi butuh apa?',
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
    this.showFilterButton = false,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autoFocus,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          if (controller != null && controller!.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
              onPressed: () {
                controller?.clear();
                onChanged?.call('');
              },
            ),
          if (showFilterButton) ...[
            Container(
              height: 24,
              width: 1,
              color: AppColors.border,
            ),
            IconButton(
              icon: const Icon(
                Icons.tune_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              onPressed: onFilterTap,
              tooltip: 'Filter',
            ),
            const SizedBox(width: 4),
          ] else
            const SizedBox(width: 8),
        ],
      ),
    );
  }
}
