import 'package:final_thesis_app/views/widgets/buttons/custom_button.dart';
import 'package:final_thesis_app/views/widgets/decorations/divider_with_margins.dart';
import 'package:final_thesis_app/views/widgets/fields/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../app/helpers/validators.dart';
import '../../app/services/authentication/authentication_service.dart';
import '../../app/services/authentication/models/auth_state.dart';
import '../../app/services/authentication/models/e_authentication_result.dart';
import '../../app/services/authentication/providers/login_state.dart';
import '../../configurations/app_colours.dart';
import '../../configurations/strings.dart';



class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends ConsumerState<RegisterView> {
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _secondNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptRegister() async {
    if (_formKey.currentState!.validate()) {
      final name = _firstNameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      final authProvider = ref.read(authenticationServiceProvider.notifier);
      await authProvider.registerWithEmailAndPassword(
          email: email, name: name, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomTextFormField firstNameFormField = CustomTextFormField(
        controller: _firstNameController,
        validator: validateName,
        labelText: Strings.username,
    );
    CustomTextFormField secondNameFormField = CustomTextFormField(
        controller: _secondNameController,
        validator: validateName,
        labelText: Strings.username,
    );
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

    CustomButton registerButton = CustomButton(
        text: Strings.register,
        onPressed: _attemptRegister,
        backgroundColor: AppColors.primaryColorLight,
        foregroundColor: AppColors.loginButtonTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
    );

    // If the user has registered successfully, we pop the current views
    ref.listen(isLoggedInProvider, (_, isLoggedIn) => context.pop());

    ref.listen(authenticationServiceProvider,
            (AuthenticationState? previous, AuthenticationState current) {
          if (current.page == "register") {
            // We check if the state is not loading and login failed
            if (current.result == EAuthenticationResult.userAlreadyExists &&
                !current.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(Strings.userExists),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });

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
                  Strings.signUp,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const DividerWithMargins(20),
                firstNameFormField,
                const SizedBox(height: 16),
                secondNameFormField,
                const SizedBox(height: 16),
                emailFormField,
                const SizedBox(height: 16),
                passwordFormField,
                const SizedBox(height: 40),
                registerButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}
