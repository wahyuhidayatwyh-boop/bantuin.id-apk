import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isSmall;

  const StatusBadge({
    super.key,
    required this.status,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    Color border;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'selesai':
      case 'tersedia':
      case 'aktif':
      case 'terverifikasi':
        bg = AppColors.successLight;
        text = AppColors.success;
        border = AppColors.successBorder;
        icon = Icons.check_circle_rounded;
        break;
      case 'berlangsung':
      case 'proses':
        bg = AppColors.primaryLight;
        text = AppColors.primary;
        border = const Color(0xFFBAE6FD);
        icon = Icons.sync_rounded;
        break;
      case 'menunggu':
      case 'pending':
        bg = AppColors.warningLight;
        text = AppColors.warning;
        border = AppColors.warningBorder;
        icon = Icons.schedule_rounded;
        break;
      case 'dibatalkan':
      case 'habis':
        bg = AppColors.dangerLight;
        text = AppColors.danger;
        border = AppColors.dangerBorder;
        icon = Icons.cancel_rounded;
        break;
      default:
        bg = AppColors.backgroundAlt;
        text = AppColors.textSecondary;
        border = AppColors.border;
        icon = Icons.info_outline_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 10,
        vertical: isSmall ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: isSmall ? 11 : 13,
            color: text,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: AppTypography.labelSmall.copyWith(
              color: text,
              fontWeight: FontWeight.w800,
              fontSize: isSmall ? 10 : 11,
            ),
          ),
        ],
      ),
    );
  }
}
