import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../data/mock_state.dart';
import '../../models/activity_model.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';

class AktivitasScreen extends StatefulWidget {
  const AktivitasScreen({super.key});

  @override
  State<AktivitasScreen> createState() => _AktivitasScreenState();
}

class _AktivitasScreenState extends State<AktivitasScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'Semua',
    'Request',
    'Lamaran',
    'Pesanan',
    'Rental',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ActivityModel> _filterActivities(List<ActivityModel> all, String tab) {
    if (tab == 'Semua') return all;
    return all.where((a) => a.type.toLowerCase() == tab.toLowerCase()).toList();
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
        final activities = MockAppState.instance.activities;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Aktivitas & Riwayat',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w900),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800, fontSize: 13),
              unselectedLabelStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: _tabs.map((tab) {
              final items = _filterActivities(activities, tab);

              if (items.isEmpty) {
                return EmptyState(
                  icon: Icons.history_rounded,
                  title: 'Belum Ada Aktivitas $tab',
                  message: 'Aktivitas transaksi, permintaan bantuan, dan pesananmu akan muncul di sini.',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final act = items[index];
                  IconData typeIcon;
                  switch (act.type) {
                    case 'Request':
                      typeIcon = Icons.post_add_rounded;
                      break;
                    case 'Lamaran':
                      typeIcon = Icons.volunteer_activism_rounded;
                      break;
                    case 'Pesanan':
                      typeIcon = Icons.design_services_rounded;
                      break;
                    default:
                      typeIcon = Icons.storefront_rounded;
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row: Type badge, Date, Status
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(typeIcon, size: 12, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    act.type,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              act.date,
                              style: AppTypography.bodySmall.copyWith(fontSize: 11),
                            ),
                            const Spacer(),
                            StatusBadge(status: act.status, isSmall: true),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Title
                        Text(
                          act.title,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Partner & Amount row
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(act.partnerAvatar),
                              backgroundColor: AppColors.primaryLight,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                act.partnerName,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              currencyFormatter.format(act.amount),
                              style: AppTypography.titleSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),

                        if (act.notes.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundAlt,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Text(
                              act.notes,
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
