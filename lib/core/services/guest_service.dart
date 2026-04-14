import '../storage/token_storage.dart';

class GuestService {

  static Future<void> loginAsGuest() async {
    await TokenStorage.saveGuestMode();
  }

  static Future<bool> isGuestMode() async {
    final isGuest = await TokenStorage.isGuestMode();
    return isGuest;
  }

  static Future<void> logoutGuest() async {
    await TokenStorage.clearAll();
  }
}