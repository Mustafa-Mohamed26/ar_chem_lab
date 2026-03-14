class UserRequestDto {
  final String username;
  final String email;
  final String password;

  UserRequestDto({
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

  factory UserRequestDto.fromJson(Map<String, dynamic> json) {
    return UserRequestDto(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}
