import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/core/constants/storage_key.dart';
import 'package:flutter_template/src/core/exceptions/app_exception.dart';
import 'package:flutter_template/src/core/providers/app_provider.dart';
import 'package:flutter_template/src/core/services/storage_service.dart';
import 'package:flutter_template/src/core/utils/app_logger.dart';
import 'package:flutter_template/src/features/auth/data/datasources/mock/auth_mock_datasource_v1.dart';
import 'package:flutter_template/src/features/auth/data/models/login_request_model.dart';
import 'package:flutter_template/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_template/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_template/src/features/auth/presentation/states/auth_state.dart';

final loginProvider = NotifierProvider<LoginNotifier, AuthState>(
  LoginNotifier.new,
);

class LoginNotifier extends Notifier<AuthState> {
  late final LoginUsecase _loginUsecase;

  @override
  AuthState build() {
    final repository = AuthRepositoryImpl(datasource: AuthMockDatasourceV1());

    _loginUsecase = LoginUsecase(repository);

    return const AuthState();
  }

  void tooglePwdVisibility() {
    state = state.copyWith(isPwdVisibile: !state.isPwdVisibile);
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _loginUsecase(
        LoginRequestModel(email: email, password: password),
      );

      if (response.success) {
        await StorageService().writeString(
          StorageKey.accessToken,
          response.data?.token ?? '',
        );
      }

      state = state.copyWith(isSuccess: true);

      ref.read(appProvider.notifier).showSuccess(response.message);
    } on DioException catch (e) {
      final error = e.error;

      if (error is AppException) {
        ref.read(appProvider.notifier).showError(error.message);
        return;
      }

      AppLogger.error(e.toString(), tag: "ERROR");
      ref.read(appProvider.notifier).showError("Something went wrong");
    } catch (e) {
      AppLogger.error(e.toString(), tag: "ERROR");
      ref.read(appProvider.notifier).showError("Something went wrong");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
