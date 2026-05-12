import 'package:flutter_template/src/core/exceptions/app_exception.dart';
import 'package:flutter_template/src/core/services/storage_service.dart';

import 'package:flutter_template/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_template/src/features/auth/data/models/login_request_model.dart';
import 'package:flutter_template/src/features/auth/data/models/signup_request_model.dart';
import 'package:flutter_template/src/features/auth/data/models/user_model.dart';

import 'package:flutter_template/src/shared/models/api_response_model.dart';

class AuthMockDatasourceV1 implements AuthRemoteDatasource {
  @override
  Future<ApiResponseModel<UserModel>> login(LoginRequestModel request) async {
    await Future.delayed(const Duration(seconds: 2));

    // invalid credentials
    if (request.email != 'admin@gmail.com' || request.password != '123456') {
      throw ApiException(message: 'Invalid email or password', statusCode: 401);
    }

    // network simulation
    if (request.email == 'network@gmail.com') {
      throw NetworkException(message: 'Please check your internet connection');
    }

    return ApiResponseModel(
      success: true,
      message: 'Login success V1',
      data: UserModel(
        id: 1,
        name: 'Smit',
        email: request.email,
        token: 'token_v1',
      ),
    );
  }

  @override
  Future<ApiResponseModel<UserModel>> signup(SignupRequestModel request) async {
    await Future.delayed(const Duration(seconds: 2));

    if (request.email == 'already@gmail.com') {
      throw ApiException(message: 'Email already exists', statusCode: 409);
    }

    return ApiResponseModel(
      success: true,
      message: 'Signup success V1',
      data: UserModel(id: 1, name: request.name, email: request.email),
    );
  }

  @override
  Future<void> logOut() async {
    await StorageService().deleteAll();
  }
}
