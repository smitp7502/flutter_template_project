import 'package:flutter_template/src/features/auth/data/models/signup_request_model.dart';
import 'package:flutter_template/src/features/auth/domain/repositories/auth_repository.dart';

class SignupUsecase {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  Future call(SignupRequestModel request) {
    return repository.signup(request);
  }
}
