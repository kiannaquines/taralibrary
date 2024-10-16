import 'package:flutter/material.dart';
import 'package:taralibrary/screens/home.dart';
import 'package:taralibrary/screens/login.dart';
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
  late Future<Widget> homeWidgetFuture;
  final MyStorage myStorage = MyStorage();

  @override
  void initState() {
    super.initState();
    homeWidgetFuture = _loadHomeWidget();
  }

  Future<Widget> _loadHomeWidget() async {
    try {
      Map<String, dynamic> tokenData = await myStorage.fetchAccessToken();
      String accessToken = tokenData['accessToken'] ?? '';
      if (accessToken.isNotEmpty) {
        return const HomeScreen();
      } else {
        return const LoginScreen();
      }
    } catch (e) {
      return const LoginScreen();
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
      home: FutureBuilder<Widget>(
        future: homeWidgetFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const LoginScreen();
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
