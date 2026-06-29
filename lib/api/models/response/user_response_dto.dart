import 'package:ar_chem_lab/domain/entities/user.dart';

class UserResponseDto {
  int? id;
  String? username;
  String? email;
  bool? disabled;
  bool? isVerified;
  String? level;
  String? message;

  UserResponseDto({
    this.id,
    this.username,
    this.email,
    this.disabled,
    this.isVerified,
    this.level,
    this.message,
  });

  UserResponseDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    disabled = json['disabled'];
    isVerified = json['is_verified'];
    level = json['level'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['disabled'] = disabled;
    data['is_verified'] = isVerified;
    data['level'] = level;
    data['message'] = message;
    return data;
  }

  User toEntity() {
    return User(
      id: id ?? -1,
      username: username ?? '',
      hashedPassword: '',
      email: email,
      disabled: disabled ?? false,
      isVerified: isVerified ?? false,
      level: level ?? 'beginner',
      resetCode: null,
    );
  }
}
