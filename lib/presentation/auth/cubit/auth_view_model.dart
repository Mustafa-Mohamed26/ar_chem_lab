import 'package:ar_chem_lab/domain/use_cases/auth_use_case.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/widgets.dart';

@injectable
class AuthViewModel extends Cubit<AuthState> {
  final AuthUseCase authUseCase;

  final formKey = GlobalKey<FormState>();
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  AuthViewModel({
    required this.authUseCase,
  }) : super(AuthInitial());

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    emit(AuthLoading());
    try {
      final responseMessage = await authUseCase.register(
        nameController.text,
        emailController.text,
        passwordController.text,
      );
      
      if (responseMessage.toLowerCase().contains("successfully") || 
          responseMessage == "User registered successfully") {
        emit(AuthSuccess(responseMessage));
      } else {
        emit(AuthError(responseMessage));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    emit(AuthLoading());
    try {
      final token = await authUseCase.login(
        nameController.text,
        passwordController.text,
      );

      // Store token in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);

      emit(AuthSuccess("Logged in successfully"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
