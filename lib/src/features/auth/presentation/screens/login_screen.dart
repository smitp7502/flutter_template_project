import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/core/listerns/app_listener.dart';
import 'package:flutter_template/src/core/routes/app_routes.dart';

import 'package:flutter_template/src/features/auth/presentation/providers/login_provider.dart';
import 'package:flutter_template/src/features/auth/presentation/widgets/screen_switcher.dart';
import 'package:flutter_template/src/shared/utils/validators.dart';
import 'package:flutter_template/src/shared/widgets/app_button.dart';
import 'package:flutter_template/src/shared/widgets/app_textfield.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();

    _passwordController = TextEditingController();

    AppListener.listen(ref);
  }

  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextField(
                suffixIcon: Icon(Icons.email_outlined),
                controller: _emailController,
                label: 'Email',
                validator: (value) =>
                    Validators().empty().email().validate(value),
              ),

              const SizedBox(height: 20),

              AppTextField(
                suffixIcon: Icon(
                  !state.isPwdVisibile
                      ? Icons.password
                      : Icons.remove_red_eye_outlined,
                ),
                tapOnSuffixIcon: () {
                  ref.read(loginProvider.notifier).tooglePwdVisibility();
                },
                controller: _passwordController,
                label: 'Password',
                obscureText: !state.isPwdVisibile,
                validator: (value) =>
                    Validators().empty().minLength(6).validate(value),
              ),

              const SizedBox(height: 30),

              AppButton(
                text: 'Login',
                isLoading: state.isLoading,
                onPressed: () async {
                  if (!(_formKey.currentState?.validate() ?? false)) {
                    return;
                  }

                  await ref
                      .read(loginProvider.notifier)
                      .login(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                  final updatedState = ref.read(loginProvider);

                  if (updatedState.isSuccess) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.homeScreen,
                      (_) => false,
                    );
                  }
                },
              ),

              const SizedBox(height: 30),

              ScreenSwitcher(
                screen: "Signup",
                title: "Don't have an account",
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.signupScreen,
                    (_) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
