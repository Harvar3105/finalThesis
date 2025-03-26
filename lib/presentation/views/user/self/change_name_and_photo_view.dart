import 'dart:developer';
import 'dart:io';

import 'package:final_thesis_app/app/helpers/validators.dart';
import 'package:final_thesis_app/presentation/views/widgets/buttons/custom_button.dart';
import 'package:final_thesis_app/presentation/views/widgets/fields/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../configurations/app_colours.dart';
import '../../../../configurations/strings.dart';
import '../../../../data/domain/user.dart';
import '../../../../data/repositories/image/image_picker_helper.dart';
import '../../../view_models/user/self/change_name_and_photo_view_model.dart';

class ChangeNamePhotoView extends ConsumerStatefulWidget {
  final User user;

  const ChangeNamePhotoView({super.key, required this.user});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangeNamePhotoPageState();
}

class _ChangeNamePhotoPageState extends ConsumerState<ChangeNamePhotoView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  File? _photoToUpload;
  bool _photoDeleted = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _photoDeleted = widget.user.avatarUrl == null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _selectPhoto() async {
    final file = await ImagePickerHelper.pickImageFromGallery();
    if (file != null) setState(() => _photoToUpload = file);
  }

  Future<void> _changeNameAndPhoto() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = ref.read(changeNamePhotoViewModelProvider.notifier);

      final updatedUser = await viewModel.changeNameAndPhoto(
        user: widget.user,
        newFirstName: _firstNameController.text.trim(),
        newLastName: _lastNameController.text.trim(),
        newPhoto: _photoToUpload,
      );
      log("Updated user: $updatedUser");

      if (_photoToUpload != null)
      {
        context.pop(updatedUser);
        context.pushReplacementNamed(Strings.userProfile, extra: updatedUser);
      }
    }
  }

  Future<void> _deleteProfilePhoto() async {
    if (!_photoDeleted) {
      final viewModel = ref.read(changeNamePhotoViewModelProvider.notifier);
      await viewModel.deleteProfilePhoto(widget.user);
      setState(() {
        _photoDeleted = true;
        _photoToUpload = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changeNamePhotoViewModelProvider);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final CustomTextFormField firstNameField = CustomTextFormField(
      controller: _firstNameController,
      labelText: Strings.newLastName,
      validator: validateName,
    );
    final CustomTextFormField lastNameField = CustomTextFormField(
      controller: _lastNameController,
      labelText: Strings.newLastName,
      validator: validateName,
    );
    final CustomButton saveButton = CustomButton(
      onPressed: _changeNameAndPhoto,
      text: Strings.save,
      backgroundColor: AppColors.primaryColorLight,
      foregroundColor: AppColors.onSurfaceColorLight,
    );

    return Scaffold(
      appBar: AppBar(title: const Text(Strings.changeNameAndPhoto)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(Strings.pfp, style: TextStyle(fontSize: 18)),
                  if (!_photoDeleted)
                    TextButton(
                      onPressed: _deleteProfilePhoto,
                      style: TextButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      child: const Text(Strings.delete, style: TextStyle(fontSize: 12)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectPhoto,
                child: _photoToUpload != null
                    ? Image.file(_photoToUpload!, fit: BoxFit.cover, height: 400,)
                    : widget.user.avatarUrl != null && !_photoDeleted
                    ? Image.network(widget.user.avatarUrl!, fit: BoxFit.cover, height: 400, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 200))
                    : const Icon(Icons.image, size: 200),
              ),
              const SizedBox(height: 20),
              firstNameField,
              const SizedBox(height: 16),
              lastNameField,
              const SizedBox(height: 16),
              saveButton
            ],
          ),
        ),
      ),
    );
  }
}
