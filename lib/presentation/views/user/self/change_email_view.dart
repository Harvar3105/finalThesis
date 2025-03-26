import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/helpers/validators.dart';
import '../../../../app/services/authentication/models/e_authentication_result.dart';
import '../../../../configurations/app_colours.dart';
import '../../../../configurations/strings.dart';
import '../../../view_models/user/self/change_email_view_model.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/fields/custom_text_form_field.dart';

class ChangeEmailView extends ConsumerStatefulWidget {
  const ChangeEmailView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends ConsumerState<ChangeEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newEmailController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  Future<void> _changeEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(changeEmailViewModelProvider.notifier).changeEmail(
        password: _passwordController.text.trim(),
        newEmail: _newEmailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(changeEmailViewModelProvider);

    ref.listen(changeEmailViewModelProvider, (previous, current) {
      if (current.page == "changeEmail" && !current.isLoading) {
        if (current.result == EAuthenticationResult.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(Strings.confirmationLink),
              backgroundColor: Colors.green,
            ),
          );
          _passwordController.clear();
          _newEmailController.clear();
        } else if (current.result == EAuthenticationResult.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(Strings.failedEmailChange),
              backgroundColor: Colors.red,
            ),
          );
        } else if (current.result == EAuthenticationResult.tooManyAttemptsTryAgainLater) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(Strings.tooManyAttempts),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.changeEmail),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: _passwordController,
                validator: validatePassword,
                labelText: Strings.password,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: _newEmailController,
                validator: validateEmail,
                labelText: Strings.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: Strings.changeEmail,
                backgroundColor: AppColors.primaryColorLight,
                foregroundColor: AppColors.loginButtonTextColor,
                onPressed: authState.isLoading ? null : _changeEmail,
              )
            ],
          ),
        ),
      ),
    );
  }
}
