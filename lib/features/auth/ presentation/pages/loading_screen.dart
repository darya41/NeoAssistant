import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    final isLoggedIn = await TokenStorage.isLoggedIn();

    final isGuest = await TokenStorage.isGuestMode();

    if (isLoggedIn && !isGuest) {
      final isValid = await ApiClient.isTokenValid();

      if (isValid && mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      } else if (mounted) {
        await TokenStorage.clearAll();
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else if (isGuest && mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    } else if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Image.asset(
          'assets/images/loading.png',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}