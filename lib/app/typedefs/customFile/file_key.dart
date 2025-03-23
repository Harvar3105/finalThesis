import 'package:flutter/cupertino.dart';

@immutable
class FileKey {
  static const thumbnailUrl = 'thumbnail_url';
  static const fileUrl = 'file_url';
  static const fileType = 'file_type';
  static const fileName = 'file_name';
  static const thumbnailStorageId = 'thumbnail_storage_id';
  static const originalFileStorageId = 'original_file_storage_id';

  static const creationDate = 'file_creation_date';
  static const modificationDate = 'file_modification_date';
}