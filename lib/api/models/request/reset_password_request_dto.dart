class ResetPasswordRequestDto {
  String? email;
  String? code;
  String? newPassword;

  ResetPasswordRequestDto({this.email, this.code, this.newPassword});

  ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    code = json['code'];
    newPassword = json['new_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['code'] = code;
    data['new_password'] = newPassword;
    return data;
  }
}
