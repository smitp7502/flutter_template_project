// lib/src/features/auth/presentation/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/app.dart';
import 'package:flutter_template/src/core/listerns/app_listener.dart';
import 'package:flutter_template/src/core/routes/app_routes.dart';
import 'package:flutter_template/src/core/utils/validators.dart';

import 'package:flutter_template/src/features/auth/presentation/providers/signup_provider.dart';
import 'package:flutter_template/src/features/auth/presentation/widgets/screen_switcher.dart';
import 'package:flutter_template/src/shared/widgets/app_button.dart';
import 'package:flutter_template/src/shared/widgets/app_textfield.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;

  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();

    _emailController = TextEditingController();

    _passwordController = TextEditingController();

    AppListener.listen(globalNavigatorKey.currentState!.context, ref);
  }

  @override
  void dispose() {
    _nameController.dispose();

    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Name',
                validator: (value) =>
                    Validators().empty().minLength(3).validate(value),
              ),

              const SizedBox(height: 20),

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
                  state.isPwdVisibile
                      ? Icons.password
                      : Icons.remove_red_eye_outlined,
                ),
                tapOnSuffixIcon: () {
                  ref.read(signupProvider.notifier).tooglePwdVisibility();
                },
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: (value) =>
                    Validators().empty().minLength(6).validate(value),
              ),

              const SizedBox(height: 30),

              AppButton(
                text: 'Signup',
                isLoading: state.isLoading,
                onPressed: () async {
                  if (!(_formKey.currentState?.validate() ?? false)) {
                    return;
                  }

                  await ref
                      .read(signupProvider.notifier)
                      .signup(
                        name: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                  if (state.isSuccess) {
                    // Navigator.pushNamedAndRemoveUntil(
                    //   context,
                    //   AppRoutes.homeScreen,
                    //   (_) => false,
                    // );
                  }
                },
              ),

              const SizedBox(height: 30),

              ScreenSwitcher(
                screen: "Login",
                title: "Already have an account",
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.loginScren,
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
