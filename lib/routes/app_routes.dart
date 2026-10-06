import 'package:flutter/material.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/request/buat_request_screen.dart';

class AppRoutes {
  static const String main = '/';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String buatRequest = '/buat-request';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case buatRequest:
        return MaterialPageRoute(builder: (_) => const BuatRequestScreen());
      default:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
    }
  }
}
