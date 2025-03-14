import 'dart:developer';
import 'dart:ffi';

import 'package:final_thesis_app/app/domain/user.dart';
import 'package:final_thesis_app/app/typedefs/e_role.dart';
import 'package:final_thesis_app/views/widgets/buttons/custom_button.dart';
import 'package:final_thesis_app/views/widgets/custom_app_bar.dart';
import 'package:final_thesis_app/views/widgets/decorations/circle_image_with_text.dart';
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
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _isSelected = [false, true];

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptRegister() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text;
      final secondName = _lastNameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final role = _isSelected[0] ? ERole.Coach : ERole.Sportsman;

      final authProvider = ref.read(authenticationServiceProvider.notifier);
      await authProvider.register(UserPayload(
        firstName: firstName,
        lastName: secondName,
        email: email,
        role: role
      ), password);
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomTextFormField firstNameFormField = CustomTextFormField(
      controller: _firstNameController,
      validator: validateName,
      labelText: Strings.firstName,
    );
    CustomTextFormField secondNameFormField = CustomTextFormField(
      controller: _lastNameController,
      validator: validateName,
      labelText: Strings.lastName,
    );
    CustomTextFormField emailFormField = CustomTextFormField(
      controller: _emailController,
      validator: validateEmail,
      labelText: Strings.email,
      keyboardType: TextInputType.emailAddress,
    );
    CustomTextFormField passwordFormField = CustomTextFormField(
      controller: _passwordController,
      validator: validatePassword, //TODO: Should be controlled in Firebase. Investigate
      labelText: Strings.password,
      obscureText: true,
    );

    CustomButton registerButton = CustomButton(
      text: Strings.register,
      onPressed: _attemptRegister,
      backgroundColor: AppColors.primaryColorLight,
      foregroundColor: AppColors.loginButtonTextColor,
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
      appBar: CustomAppBar(),
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
                const SizedBox(height: 20),
                Center(
                  child: ToggleButtons(
                    isSelected: _isSelected,
                    renderBorder: false,
                    fillColor: Colors.grey.withAlpha(120),
                    constraints: BoxConstraints(
                      minWidth: 120,
                      minHeight: 120,
                    ),
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < _isSelected.length; i++) {
                          _isSelected[i] = i == index;
                        }
                      });
                    },
                    children: [
                      CircleImageWithText(horizontalPadding: 30, verticalPadding: 15,
                          label: 'Coach', imagePath: 'assets/images/coach.png'),
                      CircleImageWithText(horizontalPadding: 30, verticalPadding: 15,
                          label: 'Sportsman', imagePath: 'assets/images/sportsman.png'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                registerButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
