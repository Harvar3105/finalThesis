import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/helpers/validators.dart';
import '../../../../app/services/authentication/models/e_authentication_result.dart';
import '../../../../configurations/app_colours.dart';
import '../../../../configurations/strings.dart';
import '../../../view_models/user/self/login_view_model.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/decorations/divider_with_margins.dart';
import '../../widgets/fields/custom_text_form_field.dart';
import '../../widgets/navigation/custom_app_bar.dart';

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
      await ref.read(loginViewModelProvider.notifier).login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(loginViewModelProvider);

    ref.listen(loginViewModelProvider, (previous, current) {
      if (current.page == "login" && !current.isLoading) {
        if (current.result == EAuthenticationResult.failure) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(Strings.wrongEmailOrPassword),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });

    return Scaffold(
      appBar: const CustomAppBar(),
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
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  Strings.logIntoYourAccount,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
                ),
                const DividerWithMargins(0),
                const SizedBox(height: 10),

                CustomTextFormField(
                  controller: _emailController,
                  validator: validateEmail,
                  labelText: Strings.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: _passwordController,
                  validator: validatePassword,
                  labelText: Strings.password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                const SizedBox(height: 40),

                CustomButton(
                  text: Strings.loginPage,
                  backgroundColor: AppColors.primaryColorLight,
                  foregroundColor: AppColors.loginButtonTextColor,
                  onPressed: authState.isLoading ? null : _attemptLogin,
                ),
                const SizedBox(height: 16),

                CustomButton(
                  text: Strings.registerPage,
                  backgroundColor: AppColors.secondaryColorLight,
                  foregroundColor: AppColors.loginButtonTextColor,
                  onPressed: () => context.push("/register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
