import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taralibrary/model/notification_models.dart';
import 'package:taralibrary/screens/home.dart';
import 'package:taralibrary/screens/login.dart';
import 'package:taralibrary/service/notification_service.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taralibrary/utils/storage.dart';
import 'package:web_socket_channel/io.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Permission.camera.request();
  await Permission.storage.request();
  await Permission.location.request();
  await Permission.notification.request();
  await Permission.criticalAlerts.request();
  await Permission.storage.request();
  
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
  late IOWebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    _initializeSocket();

    homeWidgetFuture = _loadHomeWidget();
  }

  void _initializeSocket() {
    channel = IOWebSocketChannel.connect('ws://10.0.0.169:6789');

    channel.stream.listen(
      (message) {
        if (message != null && message.isNotEmpty) {
          if (message != "ping") {
            try {
              Map<String, dynamic> jsonData = jsonDecode(message);
              ZoneData zoneData = ZoneData.fromJson(jsonData);

              debugPrint('Received ZoneData: $zoneData');

              NotificationService().showNotification(
                id: 1,
                title: 'Crowd Density Alert',
                body:
                    'Zone ${zoneData.zone} has ${zoneData.estimatedCount} detected people.',
              );
            } catch (e) {
              debugPrint('Error parsing message: $e');
            }
          } else {
            debugPrint('Received ping from server');
          }
        }
      },
      onError: (error) {
        debugPrint('WebSocket error: $error');
      },
      onDone: () {
        debugPrint('WebSocket closed');
        channel.sink.close();
      },
    );

    channel.sink.add('Hello from Flutter');
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
  void dispose() {
    channel.sink.close();
    super.dispose();
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
