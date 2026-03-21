import 'package:ar_chem_lab/domain/entities/user.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}

class ProfileLoading extends AuthState {}

class ProfileSuccess extends AuthState {
  final User user;
  ProfileSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
