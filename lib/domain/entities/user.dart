class User {
  final int id;
  final String username;
  final String? email;
  final String hashedPassword;
  final bool disabled;
  final bool isVerified;
  final String level;
  final String? resetCode;

  User({
    required this.id,
    required this.username,
    this.email,
    required this.hashedPassword,
    this.disabled = false,
    this.isVerified = false,
    this.level = 'beginner',
    this.resetCode,
  });
}
