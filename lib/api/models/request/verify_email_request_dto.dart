class VerifyEmailRequestDto {
  final String email;
  final String code;

  VerifyEmailRequestDto({required this.email, required this.code});

  Map<String, dynamic> toJson() {
    return {'email': email, 'code': code};
  }

  factory VerifyEmailRequestDto.fromJson(Map<String, dynamic> json) {
    return VerifyEmailRequestDto(
      email: json['email'] as String,
      code: json['code'] as String,
    );
  }
}
