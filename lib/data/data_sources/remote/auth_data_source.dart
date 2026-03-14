abstract class AuthDataSource {
  Future<String> register(String username, String email, String password);
  Future<String> login(String username, String password);
}
