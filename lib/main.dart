import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Цифровой помощник врача-неонатолога',
      theme: ThemeData(
        primaryColor: const Color(0xFF44E4BF),
          colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF44E4BF),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        '/login': (context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}