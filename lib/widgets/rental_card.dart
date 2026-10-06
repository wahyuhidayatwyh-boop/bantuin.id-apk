import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/rental_item_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'rating_widget.dart';
import 'status_badge.dart';

class RentalCard extends StatelessWidget {
  final RentalItemModel rental;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final bool isHorizontal;

  const RentalCard({
    super.key,
    required this.rental,
    required this.onTap,
    required this.onFavoriteTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    if (isHorizontal) {
      return Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: AppColors.cardShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image + Status + Favorite
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: AspectRatio(
                        aspectRatio: 16 / 10,
                        child: Image.network(
                          rental.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primaryLight,
                            child: const Icon(Icons.inventory_2_rounded, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: StatusBadge(
                        status: rental.status,
                        isSmall: true,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: _buildFavoriteButton(),
                    ),
                  ],
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      Text(
                        rental.category.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Name
                      Text(
                        rental.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Rating & Location
                      Row(
                        children: [
                          RatingWidget(
                            rating: rental.rating,
                            reviewCount: rental.reviewCount,
                            size: 11,
                          ),
                          const SizedBox(width: 6),
                          const Spacer(),
                          const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              rental.location.split(',').first,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(fontSize: 10.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),

                      // Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            currencyFormatter.format(rental.pricePerDay),
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            ' / hari',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Vertical List Rental Card
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with Favorite
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          rental.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primaryLight,
                            child: const Icon(Icons.inventory_2_rounded, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: _buildFavoriteButton(isSmall: true),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Body
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status & Category
                      Row(
                        children: [
                          StatusBadge(status: rental.status, isSmall: true),
                          const SizedBox(width: 6),
                          Text(
                            rental.category,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          RatingWidget(
                            rating: rental.rating,
                            reviewCount: rental.reviewCount,
                            size: 11,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Name
                      Text(
                        rental.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Owner & Location
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 8,
                            backgroundImage: NetworkImage(rental.ownerAvatar),
                            backgroundColor: AppColors.primaryLight,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              rental.ownerName,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          if (rental.isOwnerVerified) ...[
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.verified_rounded,
                              size: 12,
                              color: AppColors.primary,
                            ),
                          ],
                          const SizedBox(width: 6),
                          Text('•', style: TextStyle(color: AppColors.textDisabled, fontSize: 10)),
                          const SizedBox(width: 6),
                          const Icon(Icons.location_on_outlined, size: 11, color: AppColors.textMuted),
                          Flexible(
                            child: Text(
                              rental.location.split(',').first,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(fontSize: 10.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Price & Deposit info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            currencyFormatter.format(rental.pricePerDay),
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            ' / hari',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 10.5,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Dep: ${currencyFormatter.format(rental.deposit)}',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton({bool isSmall = false}) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onFavoriteTap,
      child: Container(
        width: isSmall ? 28 : 34,
        height: isSmall ? 28 : 34,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(color: Color(0x22000000), blurRadius: 4),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: Icon(
              rental.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(rental.isFavorite),
              color: rental.isFavorite ? AppColors.heart : AppColors.textSecondary,
              size: isSmall ? 15 : 18,
            ),
          ),
        ),
      ),
    );
  }
}
