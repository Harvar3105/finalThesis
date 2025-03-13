import 'package:final_thesis_app/views/widgets/buttons/custom_button.dart';
import 'package:final_thesis_app/views/widgets/fields/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/helpers/validators.dart';
import '../../app/services/authentication/authentication_service.dart';
import '../../app/services/authentication/models/auth_state.dart';
import '../../app/services/authentication/models/e_authentication_result.dart';
import '../../configurations/app_colours.dart';
import '../../configurations/strings.dart';
import '../widgets/decorations/divider_with_margins.dart';


class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends ConsumerState<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final authProvider = ref.read(authenticationServiceProvider.notifier);
      await authProvider.login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(authenticationServiceProvider);

    ref.listen(authenticationServiceProvider,
            (AuthenticationState? previous, AuthenticationState current) {
          if (current.page == "login") {
            // We check if the state is not loading and login failed
            if (current.result == EAuthenticationResult.failure && !current.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(Strings.wrongEmailOrPassword),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });

    CustomTextFormField emailFormField = CustomTextFormField(
      controller: _emailController,
      validator: validateEmail,
      labelText: Strings.email,
      keyboardType: TextInputType.emailAddress,
    );
    CustomTextFormField passwordFormField = CustomTextFormField(
      controller: _passwordController,
      validator: validatePassword,
      labelText: Strings.password,
    );

    CustomButton loginButton = CustomButton(
      text: Strings.login,
      backgroundColor: AppColors.primaryColorLight,
      foregroundColor: AppColors.loginButtonTextColor,
      onPressed: authProvider.isLoading ? null : _attemptLogin,
    );
    CustomButton registerButton = CustomButton(
      text: Strings.register,
      backgroundColor: AppColors.secondaryColorLight,
      foregroundColor: AppColors.loginButtonTextColor,
      onPressed: () {context.push("/register");},
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  Strings.welcomeToAppName,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 10),
                Text(
                  Strings.logIntoYourAccount,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 1.5),
                ),
                const DividerWithMargins(0),
                const SizedBox(height: 10),
                emailFormField,
                const SizedBox(height: 16),
                passwordFormField,
                const SizedBox(height: 40),
                loginButton,
                const SizedBox(height: 16),
                registerButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
