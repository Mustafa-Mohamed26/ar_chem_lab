import 'package:ar_chem_lab/domain/entities/user.dart';

class UserResponseDto {
  String? username;
  String? message;

  UserResponseDto({this.username, this.message});

  UserResponseDto.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['message'] = message;
    return data;
  }

  User toEntity() {
    return User(
      id: -1,
      username: username ?? '',
      hashedPassword: '',
      email: null,
      disabled: false,
      resetCode: null,
    );
  }
}
