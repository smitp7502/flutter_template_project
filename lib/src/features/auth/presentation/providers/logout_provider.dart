import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_template/src/core/exceptions/app_exception.dart';
import 'package:flutter_template/src/core/providers/app_provider.dart';

import 'package:flutter_template/src/features/auth/data/datasources/mock/auth_mock_datasource_v1.dart';
import 'package:flutter_template/src/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:flutter_template/src/features/auth/domain/usecases/logout_usecase.dart';

import 'package:flutter_template/src/features/auth/presentation/states/auth_state.dart';

final logoutProvider = NotifierProvider<LogoutNotifier, AuthState>(
  LogoutNotifier.new,
);

class LogoutNotifier extends Notifier<AuthState> {
  late final LogoutUsecase _logoutUsecase;

  @override
  AuthState build() {
    final repository = AuthRepositoryImpl(datasource: AuthMockDatasourceV1());

    _logoutUsecase = LogoutUsecase(repository);

    return const AuthState();
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _logoutUsecase();
      state = state.copyWith(isSuccess: true);

      ref.read(appProvider.notifier).showSuccess("Logout successfully!");
    } on AppException catch (e) {
      ref.read(appProvider.notifier).showError(e.message);
    } catch (_) {
      ref.read(appProvider.notifier).showError("Something went wrong");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
