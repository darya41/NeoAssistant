import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/ presentation/pages/login_screen.dart';
import 'features/auth/ presentation/pages/loading_screen.dart';
import 'features/main/presentation/pages/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Цифровой помощник врача-неонатолога',
      locale: const Locale('ru', 'RU'),
      theme: ThemeData(
        primaryColor: AppColors.brand_40,
          colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.brand_40,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const HomeScreen(title: 'Главная'),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}