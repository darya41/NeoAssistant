import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../main/presentation/widgets/custom_bottom_navigation_bar.dart';
import '../widgets/doctor_profile_ui.dart';
import 'doctor_edit_profile_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  Map<String, dynamic>? _doctorData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkTokenAndLoadData();
  }

  Future<void> _checkTokenAndLoadData() async {
    final isLoggedIn = await TokenStorage.isLoggedIn();

    if (!isLoggedIn) {
      setState(() {
        _errorMessage = 'Не авторизован. Войдите снова.';
        _isLoading = false;
      });
      return;
    }

    try {
      await _loadDoctorData();
    } catch (e) {
      if (e.toString().contains('401') || e.toString().contains('истек')) {
        final refreshed = await ApiClient.refreshToken();
        if (refreshed) {
          await _loadDoctorData();
        } else {
          setState(() {
            _errorMessage = 'Сессия истекла. Войдите снова.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadDoctorData() async {
    final data = await TokenStorage.getDoctorData();

    if (data == null) {
      setState(() {
        _errorMessage = 'Данные не найдены. Войдите снова.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _doctorData = data;
      _isLoading = false;
    });
  }

  Future<void> _retry() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await _checkTokenAndLoadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF44E4BF),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorEditProfileScreen(
                    doctorData: _doctorData!,
                  ),
                ),
              ).then((updatedData) {
                if (updatedData != null) {
                  setState(() {
                    _doctorData!.addAll(updatedData);
                  });
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _retry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF44E4BF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Повторить',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: DoctorInfoCard(doctorData: _doctorData!),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3),
    );
  }
}