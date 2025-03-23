import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/helpers/validators.dart';
import '../../../../app/services/authentication/models/e_authentication_result.dart';
import '../../../../app/typedefs/e_role.dart';
import '../../../../configurations/app_colours.dart';
import '../../../../configurations/strings.dart';
import '../../../../data/domain/user.dart';
import '../../../view_models/user/self/register_view_model.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/decorations/circle_image_with_text.dart';
import '../../widgets/decorations/divider_with_margins.dart';
import '../../widgets/fields/custom_text_form_field.dart';
import '../../widgets/navigation/custom_app_bar.dart';

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
      final lastName = _lastNameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final role = _isSelected[0] ? ERole.coach : ERole.athlete;

      await ref.read(registerViewModelProvider.notifier).register(
        UserPayload(
          firstName: firstName,
          lastName: lastName,
          email: email,
          role: role,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
        password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(registerViewModelProvider);

    ref.listen(registerViewModelProvider, (previous, current) {
      if (current.page == "register" && !current.isLoading) {
        if (current.result == EAuthenticationResult.userAlreadyExists) {
          ScaffoldMessenger.of(context).clearSnackBars();
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
                  Strings.signUp,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const DividerWithMargins(20),

                CustomTextFormField(
                  controller: _firstNameController,
                  validator: validateName,
                  labelText: Strings.firstName,
                ),
                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: _lastNameController,
                  validator: validateName,
                  labelText: Strings.lastName,
                ),
                const SizedBox(height: 16),

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
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                Center(
                  child: ToggleButtons(
                    isSelected: _isSelected,
                    renderBorder: false,
                    fillColor: Colors.grey.withAlpha(120),
                    constraints: const BoxConstraints(
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
                      CircleImageWithText(
                        horizontalPadding: 30,
                        verticalPadding: 15,
                        label: 'Coach',
                        imagePath: 'assets/images/coach.png',
                      ),
                      CircleImageWithText(
                        horizontalPadding: 30,
                        verticalPadding: 15,
                        label: 'Sportsman',
                        imagePath: 'assets/images/sportsman.png',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                CustomButton(
                  text: Strings.registerPage,
                  onPressed: _attemptRegister,
                  backgroundColor: AppColors.primaryColorLight,
                  foregroundColor: AppColors.loginButtonTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
