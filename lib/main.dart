import 'package:flutter/material.dart';
import 'package:taralibrary/screens/home.dart';
import 'package:taralibrary/service/notification_service.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taralibrary/utils/storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final String accessToken;

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
  }

  MyStorage myStorage = MyStorage();

  Future<void> _loadAccessToken() async {
    try {
      Map<String, dynamic> tokenData = await myStorage.fetchAccessToken();
      accessToken = tokenData['accessToken'] ?? '';
    } catch (e) {
      accessToken = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaraLibrary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
        ),
        scaffoldBackgroundColor: AppColors.white,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
