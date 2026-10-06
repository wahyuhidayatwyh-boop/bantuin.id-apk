import 'package:flutter/material.dart';
import '../data/mock_state.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_navigation.dart';
import 'home/home_screen.dart';
import 'jasa/jasa_screen.dart';
import 'bantuan/bantuan_screen.dart';
import 'sewa/sewa_screen.dart';
import 'aktivitas/aktivitas_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MockAppState.instance,
      builder: (context, _) {
        final state = MockAppState.instance;
        final currentIndex = state.currentTabIndex;

        final screens = [
          const HomeScreen(),
          const JasaScreen(),
          const BantuanScreen(),
          const SewaScreen(),
          const AktivitasScreen(),
        ];

        return Scaffold(
          appBar: AppHeader(
            onProfileTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          body: IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          bottomNavigationBar: AppBottomNavigation(
            currentIndex: currentIndex,
            onTap: (index) {
              state.setTabIndex(index);
            },
          ),
        );
      },
    );
  }
}
