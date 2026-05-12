import 'package:flutter_template/src/features/auth/data/models/login_request_model.dart';
import 'package:flutter_template/src/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future call(LoginRequestModel request) {
    return repository.login(request);
  }
}
