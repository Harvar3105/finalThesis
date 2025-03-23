import 'dart:io';

import 'package:final_thesis_app/app/models/domain/user.dart';
import 'package:final_thesis_app/app/storage/user/user_strorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/storage/image/image_picker_helper.dart';
import '../../../app/storage/image/image_storage.dart';
import '../../../configurations/app_colours.dart';
import '../../../configurations/strings.dart';
import '../../widgets/animations/loading/loading_screen.dart';

class ChangeNamePhotoView extends ConsumerStatefulWidget {
  final UserPayload userPayload;

  const ChangeNamePhotoView({super.key, required this.userPayload});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangeNamePhotoPageState();
}

class _ChangeNamePhotoPageState extends ConsumerState<ChangeNamePhotoView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _scrollController = ScrollController();
  final _nameFocusNode = FocusNode();
  File? _photoToUpload;

  bool _photoDeleted = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.userPayload.firstName ?? '';
    _lastNameController.text = widget.userPayload.lastName ?? '';

    _photoDeleted = widget.userPayload.imageName == null && widget.userPayload.thumbnailName == null;

    _nameFocusNode.addListener(() {
      if (_nameFocusNode.hasFocus) {
        _scrollToField();
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _scrollController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _scrollToField() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _selectPhoto() async {
    final File? file = await ImagePickerHelper.pickImageFromGallery();
    if (file != null) {
      setState(() {
        _photoToUpload = file;
      });
    }
  }

  Future<void> _changeNameAndPhoto() async {
    if (_formKey.currentState?.validate() ?? false) {
      LoadingScreen.instance().show(context: context);

      try {
        final newName = _firstNameController.text.trim();
        const userInfoStorage = UserStorage();

        Map<String, String>? imageData;

        if (_photoToUpload != null) {
          _deleteProfilePhoto(deleteOnlyFromSupabase: true);

          imageData = await ref.read(imageUploadProvider.notifier).uploadUserImageToStorage(
            file: _photoToUpload!,
            userId: widget.userPayload.id,
          );

          if (imageData == null) {
            throw Exception('Failed to upload photo');
          }
          setState(() {
            _photoDeleted = false;
          });
        }

        final success = await userInfoStorage.saveOrUpdateUserInfo(
          userId: widget.userPayload.id,
          displayName: newName,
          imageURL: imageData?['imageUrl'],
          imageName: imageData?['imageName'],
          thumbnailUrl: imageData?['thumbnailUrl'],
          thumbnailName: imageData?['thumbnailName'],
        );

        if (!success) {
          throw Exception('Name and photo update failed!');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Strings.updateSuccess),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        LoadingScreen.instance().hide();
      }
    }
  }

  Future<void> _deleteProfilePhoto({bool deleteOnlyFromSupabase = false}) async {
    if (!_photoDeleted) {
      LoadingScreen.instance().show(context: context);

      try {
        const userInfoStorage = UserStorage();

        bool imageDeleted = await ref.read(imageUploadProvider.notifier).deleteUserImageFromStorage(
          id: widget.userPayload.id,
          );

          if (!imageDeleted) {
            throw Exception('Failed to delete photo');
          }

        if (!deleteOnlyFromSupabase) {
          final success = await userInfoStorage.deleteUserPicture(
            id: widget.userPayload.id,
          );

          if (!success) {
            throw Exception('Failed to delete photo');
          }

          setState(() {
            _photoDeleted = true;
            _photoToUpload = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(Strings.photoDeleteSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }

      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        LoadingScreen.instance().hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.changeNameAndPhoto),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      Strings.pfp,
                      style: TextStyle(fontSize: 18),
                    ),
                    if (!_photoDeleted)
                      TextButton(
                        onPressed: _deleteProfilePhoto,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(Strings.delete, style: TextStyle(fontSize: 12),),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                      onTap: _selectPhoto,
                      child: _photoToUpload == null && widget.userPayload.imageURL != null && !_photoDeleted
                          ? Image.network(
                        widget.userPayload.imageURL!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 200),
                      )
                          : _photoToUpload != null
                          ? Image.file(
                        _photoToUpload!,
                        fit: BoxFit.cover,
                      )
                          : const Icon(Icons.image, size: 200),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton(
                        onPressed: _selectPhoto,
                        mini: true,
                        backgroundColor: theme.primaryColor,
                        child: const Icon(Icons.edit, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _firstNameController,
                  focusNode: _nameFocusNode,
                  decoration: const InputDecoration(
                    labelText: Strings.newName,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Strings.nameIsRequired;
                    }
                    return null;
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
                  onPressed: _changeNameAndPhoto,
                  child: const Text(Strings.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
