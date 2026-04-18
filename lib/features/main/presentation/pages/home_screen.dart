import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/guest_service.dart';
import '../widgets/home_screen_ui.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  final String? initialTab;

  const HomeScreen({
    super.key,
    required this.title,
    this.initialTab,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGuest = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserMode();
  }

  Future<void> _checkUserMode() async {
    final isGuest = await GuestService.isGuestMode();

    if (mounted) {
      setState(() {
        _isGuest = isGuest;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primary,
      ),
      body: HomeScreenUI(
          isGuest: _isGuest,
          initialTab: widget.initialTab,
      ),
    );
  }
}