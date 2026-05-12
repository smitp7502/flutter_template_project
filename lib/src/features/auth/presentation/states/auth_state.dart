class AuthState {
  final bool isLoading;
  final bool isPwdVisibile;
  final bool isSuccess;

  const AuthState({
    this.isLoading = false,
    this.isPwdVisibile = false,
    this.isSuccess = false,
  });

  AuthState copyWith({bool? isLoading, bool? isPwdVisibile, bool? isSuccess}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isPwdVisibile: isPwdVisibile ?? this.isPwdVisibile,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
