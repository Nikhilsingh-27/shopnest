import '../../core/storage/token_storage.dart';
import '../providers/auth_provider.dart';

class AuthRepository {
  final AuthProvider provider = AuthProvider();
  final TokenStorage storage = TokenStorage();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await provider.login(email, password);

    if (response.data["success"] == true) {
      final token = response.data["data"]["token"];
      final user = response.data["data"]["user"];

      storage.saveAuthData(token, user);
    }
    return response.data;
  }
}
