import 'package:flutter_template/src/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future call() {
    return repository.onLogout();
  }
}
