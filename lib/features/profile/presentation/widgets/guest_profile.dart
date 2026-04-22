import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/ presentation/pages/login_screen.dart';
import '../../../main/presentation/pages/home_screen.dart';

class GuestProfile extends StatelessWidget {
  final VoidCallback? onLoginPressed;
  final VoidCallback? onContinueAsGuest;

  const GuestProfile({
    super.key,
    this.onLoginPressed,
    this.onContinueAsGuest,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'Вы вошли как гость',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Войдите в профиль, чтобы просматривать и редактировать\n'
                  'личную информацию, настройки и историю наблюдений',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                if (onLoginPressed != null) {
                  onLoginPressed!();
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Войти в профиль',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                if (onContinueAsGuest != null) {
                  onContinueAsGuest!();
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(
                        title: 'Главная',
                        initialTab: 'Аналитика',
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Продолжить как гость',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}