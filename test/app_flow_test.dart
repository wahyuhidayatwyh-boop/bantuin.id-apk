import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bantuin_app/main.dart';
import 'package:bantuin_app/data/mock_state.dart';

final List<int> _transparentPng = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _MockHttpClientRequest();
  }
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse();
  }
}

class _MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _transparentPng.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_transparentPng]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('Full app navigation and tabs test', (WidgetTester tester) async {
    await tester.pumpWidget(const BantuinApp());
    await tester.pumpAndSettle();

    // 1. Initial Beranda Tab
    expect(find.text('Bantuin'), findsWidgets);
    expect(find.text('KATEGORI LAYANAN'), findsOneWidget);

    // 2. Navigate to Jasa Tab
    await tester.tap(find.text('Jasa'));
    await tester.pumpAndSettle();
    expect(MockAppState.instance.currentTabIndex, 1);
    expect(find.text('Menampilkan 5 jasa'), findsOneWidget);

    // 3. Navigate to Bantuan Tab
    await tester.tap(find.text('Bantuan'));
    await tester.pumpAndSettle();
    expect(MockAppState.instance.currentTabIndex, 2);
    expect(find.text('Tersedia 5 permintaan bantuan'), findsOneWidget);

    // 4. Navigate to Sewa Tab
    await tester.tap(find.text('Sewa'));
    await tester.pumpAndSettle();
    expect(MockAppState.instance.currentTabIndex, 3);
    expect(find.text('Tersedia 6 barang rental'), findsOneWidget);

    // 5. Navigate to Aktivitas Tab
    await tester.tap(find.text('Aktivitas'));
    await tester.pumpAndSettle();
    expect(MockAppState.instance.currentTabIndex, 4);
    expect(find.text('Aktivitas & Riwayat'), findsOneWidget);

    // 6. Test Favorite toggle
    final initialServices = MockAppState.instance.services;
    final initialFav = initialServices.first.isFavorite;
    MockAppState.instance.toggleServiceFavorite(initialServices.first.id);
    expect(MockAppState.instance.services.first.isFavorite, !initialFav);
  });

  testWidgets('Profile and Edit Profile screen flow test', (WidgetTester tester) async {
    await tester.pumpWidget(const BantuinApp());
    await tester.pumpAndSettle();

    // 1. Open Profile Screen via AppHeader profile avatar button
    final profileButton = find.byKey(const ValueKey('header_profile_button'));
    expect(profileButton, findsOneWidget);
    await tester.tap(profileButton);
    await tester.pumpAndSettle();

    // Verify Profile Screen
    expect(find.text('Profil Pengguna'), findsOneWidget);
    expect(find.text('Edit Profil'), findsWidgets);
    expect(find.text('Riwayat Transaksi'), findsOneWidget);
    expect(find.text('Pengaturan Akun'), findsOneWidget);

    // 2. Tap Edit Profil button on Profile Screen
    await tester.tap(find.text('Edit Profil').first);
    await tester.pumpAndSettle();

    // Verify Edit Profile Screen is open
    expect(find.text('INFORMASI PENGGUNA'), findsOneWidget);
    expect(find.text('Nama Lengkap *'), findsOneWidget);
    expect(find.text('Ubah Foto Profil'), findsOneWidget);
    expect(find.text('MINAT & KATEGORI LAYANAN'), findsOneWidget);
    expect(find.text('Simpan Perubahan'), findsOneWidget);

    // 3. Edit user's bio or location
    MockAppState.instance.updateUserProfile(
      name: 'Rizky Pratama Ganteng',
      phone: '+62 812-3456-7890',
      location: 'Purwokerto Utara, Banyumas',
      bio: 'Freelance web & mobile developer di Banyumas.',
    );
    await tester.pumpAndSettle();

    // Verify state was updated
    expect(MockAppState.instance.currentUser.name, 'Rizky Pratama Ganteng');
    expect(MockAppState.instance.currentUser.location, 'Purwokerto Utara, Banyumas');
  });
}

