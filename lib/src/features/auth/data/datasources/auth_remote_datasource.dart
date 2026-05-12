// lib/src/features/auth/data/datasources/auth_remote_datasource.dart

import 'package:flutter_template/src/features/auth/data/models/login_request_model.dart';
import 'package:flutter_template/src/features/auth/data/models/signup_request_model.dart';
import 'package:flutter_template/src/features/auth/data/models/user_model.dart';
import 'package:flutter_template/src/shared/models/api_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<ApiResponseModel<UserModel>> login(LoginRequestModel request);

  Future<ApiResponseModel<UserModel>> signup(SignupRequestModel request);

  Future<void> logOut();
}
