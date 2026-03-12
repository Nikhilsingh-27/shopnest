import 'package:get_storage/get_storage.dart';

class TokenStorage {
  final box = GetStorage();

  void saveAuthData(String token, Map<String, dynamic> user) {
    box.write("token", token);
    box.write("user", user);
    box.write(
      "expiry",
      DateTime.now().add(const Duration(days: 30)).toString(),
    );
  }

  String? getToken() {
    return box.read("token");
  }

  Map<String, dynamic>? getUser() {
    return box.read("user");
  }

  bool isTokenValid() {
    String? expiry = box.read("expiry");

    if (expiry == null) return false;

    return DateTime.now().isBefore(DateTime.parse(expiry));
  }

  void clearAuth() {
    box.remove("token");
    box.remove("user");
    box.remove("expiry");
  }
}
