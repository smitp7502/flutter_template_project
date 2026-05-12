import 'package:flutter_template/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_template/src/features/auth/data/models/login_request_model.dart';
import 'package:flutter_template/src/features/auth/data/models/signup_request_model.dart';
import 'package:flutter_template/src/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_template/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_template/src/shared/models/api_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  @override
  Future<ApiResponseModel<UserEntity>> login(LoginRequestModel request) {
    return datasource.login(request);
  }

  @override
  Future<ApiResponseModel<UserEntity>> signup(SignupRequestModel request) {
    return datasource.signup(request);
  }

  @override
  Future<void> onLogout() async {
    await datasource.logOut();
  }
}
