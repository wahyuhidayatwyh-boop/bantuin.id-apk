import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../models/help_request_model.dart';
import '../models/rental_item_model.dart';
import '../models/activity_model.dart';
import '../models/user_model.dart';
import 'mock_data.dart';

class MockAppState extends ChangeNotifier {
  static final MockAppState instance = MockAppState._internal();
  factory MockAppState() => instance;
  MockAppState._internal() {
    _services = List.from(MockData.initialServices);
    _helpRequests = List.from(MockData.initialHelpRequests);
    _rentals = List.from(MockData.initialRentals);
    _activities = List.from(MockData.initialActivities);
  }

  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  String _selectedLocation = 'Kab. Banyumas';
  String get selectedLocation => _selectedLocation;

  UserModel _currentUser = MockData.currentUser;
  UserModel get currentUser => _currentUser;

  void updateUserProfile({
    required String name,
    required String phone,
    required String location,
    String? bio,
    String? avatar,
  }) {
    _currentUser = _currentUser.copyWith(
      name: name,
      phone: phone,
      location: location,
      bio: bio,
      avatar: avatar,
    );
    notifyListeners();
  }

  int _unreadNotifications = 3;
  int get unreadNotifications => _unreadNotifications;

  void clearNotifications() {
    _unreadNotifications = 0;
    notifyListeners();
  }

  late List<ServiceModel> _services;
  List<ServiceModel> get services => _services;

  late List<HelpRequestModel> _helpRequests;
  List<HelpRequestModel> get helpRequests => _helpRequests;

  late List<RentalItemModel> _rentals;
  List<RentalItemModel> get rentals => _rentals;

  late List<ActivityModel> _activities;
  List<ActivityModel> get activities => _activities;

  // Selected filters for pages
  String _selectedServiceCategory = 'Semua';
  String get selectedServiceCategory => _selectedServiceCategory;

  String _selectedHelpCategory = 'Semua';
  String get selectedHelpCategory => _selectedHelpCategory;

  String _selectedRentalCategory = 'Semua';
  String get selectedRentalCategory => _selectedRentalCategory;

  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  void setLocation(String loc) {
    _selectedLocation = loc;
    notifyListeners();
  }

  void setServiceCategory(String category) {
    _selectedServiceCategory = category;
    notifyListeners();
  }

  void setHelpCategory(String category) {
    _selectedHelpCategory = category;
    notifyListeners();
  }

  void setRentalCategory(String category) {
    _selectedRentalCategory = category;
    notifyListeners();
  }

  void toggleServiceFavorite(String serviceId) {
    final idx = _services.indexWhere((s) => s.id == serviceId);
    if (idx != -1) {
      final updated = _services[idx].copyWith(
        isFavorite: !_services[idx].isFavorite,
      );
      _services[idx] = updated;
      notifyListeners();
    }
  }

  void toggleRentalFavorite(String rentalId) {
    final idx = _rentals.indexWhere((r) => r.id == rentalId);
    if (idx != -1) {
      final updated = _rentals[idx].copyWith(
        isFavorite: !_rentals[idx].isFavorite,
      );
      _rentals[idx] = updated;
      notifyListeners();
    }
  }

  void addHelpRequest(HelpRequestModel newRequest) {
    _helpRequests.insert(0, newRequest);
    _activities.insert(
      0,
      ActivityModel(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}',
        type: 'Request',
        title: newRequest.title,
        partnerName: 'Bantuin System',
        partnerAvatar: _currentUser.avatar,
        amount: newRequest.budget,
        status: 'Menunggu',
        date: 'Baru saja',
        notes: 'Permintaan bantuan berhasil dipublikasikan',
      ),
    );
    notifyListeners();
  }

  void bookRental({
    required RentalItemModel item,
    required DateTime startDate,
    required DateTime endDate,
    required int durationDays,
    required int totalPrice,
  }) {
    _activities.insert(
      0,
      ActivityModel(
        id: 'act-rnt-${DateTime.now().millisecondsSinceEpoch}',
        type: 'Rental',
        title: 'Sewa ${item.name}',
        partnerName: item.ownerName,
        partnerAvatar: item.ownerAvatar,
        amount: totalPrice,
        status: 'Berlangsung',
        date: 'Baru saja',
        notes: 'Durasi $durationDays hari (${startDate.day}/${startDate.month} - ${endDate.day}/${endDate.month})',
      ),
    );
    notifyListeners();
  }

  void orderService({
    required ServiceModel service,
    required String selectedSubService,
    required int price,
  }) {
    _activities.insert(
      0,
      ActivityModel(
        id: 'act-srv-${DateTime.now().millisecondsEpoch}',
        type: 'Pesanan',
        title: selectedSubService.isNotEmpty ? selectedSubService : service.title,
        partnerName: service.providerName,
        partnerAvatar: service.providerAvatar,
        amount: price,
        status: 'Menunggu',
        date: 'Baru saja',
        notes: 'Pesanan jasa terkirim, menunggu konfirmasi penyedia',
      ),
    );
    notifyListeners();
  }

  void applyHelp({
    required HelpRequestModel request,
    required String message,
  }) {
    _activities.insert(
      0,
      ActivityModel(
        id: 'act-hlp-${DateTime.now().millisecondsEpoch}',
        type: 'Lamaran',
        title: 'Bantu: ${request.title}',
        partnerName: request.requesterName,
        partnerAvatar: request.requesterAvatar,
        amount: request.budget,
        status: 'Menunggu',
        date: 'Baru saja',
        notes: 'Lamaran terkirim ke pembuat request',
      ),
    );
    notifyListeners();
  }
}

extension on DateTime {
  int get millisecondsEpoch => millisecondsSinceEpoch;
}
