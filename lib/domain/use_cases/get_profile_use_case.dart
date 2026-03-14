import 'package:ar_chem_lab/domain/entities/user.dart';
import 'package:ar_chem_lab/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProfileUseCase {
  final AuthRepository repository;

  GetProfileUseCase({required this.repository});

  Future<User> invoke() async {
    return await repository.getProfile();
  }
}
