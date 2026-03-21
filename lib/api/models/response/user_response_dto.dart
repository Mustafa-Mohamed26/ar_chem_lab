import 'package:ar_chem_lab/domain/entities/user.dart';

class UserResponseDto {
  String? username;
  String? email;
  String? message;

  UserResponseDto({this.username, this.email, this.message});

  UserResponseDto.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['message'] = message;
    return data;
  }

  User toEntity() {
    return User(
      id: -1,
      username: username ?? '',
      hashedPassword: '',
      email: email,
      disabled: false,
      resetCode: null,
    );
  }
}
