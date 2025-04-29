import 'dart:typed_data';

class CustomImageFile {
  final String name;
  final Uint8List data;
  final String? path;

  CustomImageFile({
    required this.name,
    required this.data,
    this.path,
  });
}