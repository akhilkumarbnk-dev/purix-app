import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const PurixAcademyApp());
}

class PurixAcademyApp extends StatelessWidget {
  const PurixAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const darkVoid = Color(0xFF070B14);
    const surfaceColor = Color(0xFF0B111E);
    const neonCyan = Color(0xFF00F0FF);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Purix Academy',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkVoid,
        canvasColor: darkVoid,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: surfaceColor,
        ),
        colorScheme: const ColorScheme.dark(
          primary: neonCyan,
          surface: surfaceColor,
        ), dialogTheme: DialogThemeData(backgroundColor: surfaceColor),
      ),
      home: const LoginScreen(),
    );
  }
}