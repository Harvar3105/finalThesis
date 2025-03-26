import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  File? _photoToUpload;
  bool _photoDeleted = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.user.firstName;
    _photoDeleted = widget.user.avatarUrl == null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    super.dispose();
  }

  Future<void> _selectPhoto() async {
    final file = await ImagePickerHelper.pickImageFromGallery();
    if (file != null) setState(() => _photoToUpload = file);
  }

  Future<void> _changeNameAndPhoto() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = ref.read(changeNamePhotoViewModelProvider.notifier);

      await viewModel.changeNameAndPhoto(
        user: widget.user,
        newFirstName: _firstNameController.text.trim(),
        newPhoto: _photoToUpload,
      );

      if (_photoToUpload != null) setState(() => _photoDeleted = false);
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
    final theme = Theme.of(context);

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
                    ? Image.file(_photoToUpload!, fit: BoxFit.cover)
                    : widget.user.avatarUrl != null && !_photoDeleted
                    ? Image.network(widget.user.avatarUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 200))
                    : const Icon(Icons.image, size: 200),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: Strings.newName, border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? Strings.nameIsRequired : null,
              ),
              const SizedBox(height: 16),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryColorLight,
                  foregroundColor: AppColors.loginButtonTextColor,
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: _changeNameAndPhoto,
                child: const Text(Strings.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
