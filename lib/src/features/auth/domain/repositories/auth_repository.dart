import 'package:flutter_template/src/features/auth/data/models/login_request_model.dart';
import 'package:flutter_template/src/features/auth/data/models/signup_request_model.dart';
import 'package:flutter_template/src/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_template/src/shared/models/api_response_model.dart';

abstract class AuthRepository {
  Future<ApiResponseModel<UserEntity>> login(LoginRequestModel request);

  Future<ApiResponseModel<UserEntity>> signup(SignupRequestModel request);

  Future<void> onLogout();
}
