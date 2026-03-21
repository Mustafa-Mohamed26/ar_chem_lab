class LoginResponseDto {
  String? accessToken;
  String? refreshToken;
  String? tokenType;

  LoginResponseDto({this.accessToken, this.refreshToken, this.tokenType});

  LoginResponseDto.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    data['token_type'] = tokenType;
    return data;
  }
}
