import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/core/exceptions/app_exception.dart';
import 'package:flutter_template/src/core/providers/app_provider.dart';
import 'package:flutter_template/src/core/utils/app_logger.dart';
import 'package:flutter_template/src/features/auth/data/datasources/mock/auth_mock_datasource_v1.dart';
import 'package:flutter_template/src/features/auth/data/models/signup_request_model.dart';
import 'package:flutter_template/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_template/src/features/auth/domain/usecases/signup_usecase.dart';
import 'package:flutter_template/src/features/auth/presentation/states/auth_state.dart';

final signupProvider = NotifierProvider<SignupNotifier, AuthState>(
  SignupNotifier.new,
);

class SignupNotifier extends Notifier<AuthState> {
  late final SignupUsecase _signupUsecase;

  @override
  AuthState build() {
    final repository = AuthRepositoryImpl(datasource: AuthMockDatasourceV1());

    _signupUsecase = SignupUsecase(repository);

    return const AuthState();
  }

  void tooglePwdVisibility() {
    state = state.copyWith(isPwdVisibile: !state.isPwdVisibile);
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      await _signupUsecase(
        SignupRequestModel(name: name, email: email, password: password),
      );

      state = state.copyWith(isSuccess: true);
    } on DioException catch (e) {
      final error = e.error;

      if (error is AppException) {
        ref.read(appProvider.notifier).showError(error.message);
      }

      ref.read(appProvider.notifier).showError("Something went wrong");
    } catch (e) {
      AppLogger.error(e.toString(), tag: "ERROR");
      ref.read(appProvider.notifier).showError("Something went wrong");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
