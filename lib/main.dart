import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neo Friend',
      theme: ThemeData(
        primaryColor: const Color(0xFF44E4BF),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF44E4BF),
        ),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/*import 'package:flutter/material.dart';
import 'screens/protocol_search_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/calculations_screen.dart';
import 'widgets/main/home_screen_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neo Friend',
      theme: ThemeData(
        primaryColor: const Color(0xFF44E4BF),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF44E4BF),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// установка загрузки
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'Neo Friend - Главная'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingScreen();
  }
}

// установка главного экрана
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _openProtocolSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProtocolSearchScreen(),
      ),
    );
  }

  void _openCalculations() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CalculationsScreen(),
      ),
    );
  }

  // Подключение интерфейс главного
  @override
  Widget build(BuildContext context) {
    return HomeScreenUI(
      title: widget.title,
      onProtocolSearch: _openProtocolSearch,
      onCalculations: _openCalculations,
    );

  }
}*/
