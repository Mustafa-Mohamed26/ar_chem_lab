import 'package:ar_chem_lab/domain/use_cases/register_use_case.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter/widgets.dart';

@injectable
class AuthViewModel extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  AuthViewModel({required this.registerUseCase}) : super(AuthInitial());

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
      final responseMessage = await registerUseCase.invoke(
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
}
