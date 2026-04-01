import 'package:flutter/material.dart';
import 'data/database_helper.dart';
import 'screens/login_page.dart';

void main() async {
  // Wajib ditambahkan agar Flutter siap menjalankan kode async sebelum UI tampil
  WidgetsFlutterBinding.ensureInitialized();

  // Menyalakan dan menginisialisasi Database SQLite kita
  await DatabaseHelper.initDatabase();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Saat aplikasi disembunyikan ke background/riwayat atau keluar
    if (state == AppLifecycleState.paused) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Digunakan agar bisa navigasi secara global
      title: 'Admin Coffeeshop',
      // Kita pakai warna tema bernuansa kopi (brown)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
