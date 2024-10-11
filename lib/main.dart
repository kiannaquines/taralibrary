import 'package:flutter/material.dart';
import 'package:taralibrary/screens/home.dart';
import 'package:taralibrary/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
