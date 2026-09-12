import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  final String? savedClass = prefs.getString('user_class');
  final String? userName = prefs.getString('user_name');

  runApp(PurixApp(
    initialScreen: (isLoggedIn && savedClass != null)
        ? DashboardScreen(selectedClass: savedClass, userName: userName ?? 'Student')
        : const LoginScreen(),
  ));
}

class PurixApp extends StatelessWidget {
  final Widget initialScreen;
  const PurixApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purix Academy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: initialScreen,
    );
  }
}