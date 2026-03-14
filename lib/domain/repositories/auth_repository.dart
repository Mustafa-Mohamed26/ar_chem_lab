abstract class AuthRepository {
  Future<String> register(String username, String email, String password);
}
