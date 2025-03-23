import 'package:final_thesis_app/app/services/authentication/authentication_service.dart';
import 'package:final_thesis_app/app/services/authentication/models/auth_state.dart';
import 'package:final_thesis_app/app/services/authentication/models/e_authentication_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/helpers/validators.dart';
import '../../../configurations/app_colours.dart';
import '../../../configurations/strings.dart';

class ChangePasswordView extends ConsumerStatefulWidget {

  const ChangePasswordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final oldPassword = _oldPasswordController.text.trim();
      final newPassword = _newPasswordController.text.trim();

      final authProvider = ref.read(authenticationServiceProvider.notifier);
      await authProvider.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authenticationServiceProvider);

    ref.listen(authenticationServiceProvider, (AuthenticationState? previous, AuthenticationState current) {
      if (current.page == "changePassword") {
        if (current.result == EAuthenticationResult.success && !current.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(Strings.passChangedSuccess),
                backgroundColor: Colors.green),
          );
          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        } else if (current.result == EAuthenticationResult.failure && !current.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(Strings.passChangeFailed),
              backgroundColor: Colors.red,),
          );
        } else if (current.result == EAuthenticationResult.tooManyAttemptsTryAgainLater &&
            !current.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(Strings.tooManyAttempts),
                backgroundColor: Colors.red),
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.userProfile),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(Strings.changePassword, style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _oldPasswordController,
                decoration: const InputDecoration(
                  labelText: Strings.oldPassword,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: validatePassword,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: Strings.newPassword,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: validatePassword,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: Strings.confirmNewPassword,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return Strings.passwordMismatch;
                  }
                  return validatePassword(value);
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryColorLight,
                  foregroundColor: AppColors.loginButtonTextColor,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: authState.isLoading ? null : _changePassword,
                child: const Text(Strings.changePassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
