class RegisterRequestDto {
  final String username;
  final String email;
  final String password;

  RegisterRequestDto({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) {
    return RegisterRequestDto(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}
