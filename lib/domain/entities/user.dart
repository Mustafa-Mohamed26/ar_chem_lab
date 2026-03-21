class User {
  final int id;
  final String username;
  final String? email;
  final String hashedPassword;
  final bool disabled;
  final String? resetCode;

  User({
    required this.id,
    required this.username,
    this.email,
    required this.hashedPassword,
    this.disabled = false,
    this.resetCode,
  });
}
