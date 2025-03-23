import 'package:cloud_firestore/cloud_firestore.dart';

import 'file_key.dart';
import 'file_type.dart';


class CustomFile{
  final String thumbnailUrl;
  final String fileUrl;
  final FileType fileType;
  final String fileName;
  final String thumbnailStorageId;
  final String originalFileStorageId;

  late final DateTime creationDate;
  late DateTime modificationDate;

  CustomFile({
    required Map<String, dynamic> json
  }) : thumbnailUrl = json[FileKey.thumbnailUrl],
  fileUrl = json[FileKey.fileUrl],
  fileType = FileType.values.firstWhere(
    (fileType) => fileType.name == json[FileKey.fileType],
    orElse: () => FileType.image,
  ),
  fileName = json[FileKey.fileName],
  thumbnailStorageId = json[FileKey.thumbnailStorageId],
  originalFileStorageId = json[FileKey.originalFileStorageId],
  creationDate = (json[FileKey.creationDate] as Timestamp).toDate(),
  modificationDate = (json[FileKey.modificationDate] as Timestamp).toDate();

  CustomFile.fromData(
      this.thumbnailUrl,
      this.fileUrl,
      this.fileType,
      this.fileName,
      this.thumbnailStorageId,
      this.originalFileStorageId,
      ){
    modificationDate = DateTime.now();
    creationDate = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      FileKey.thumbnailUrl: thumbnailUrl,
      FileKey.fileUrl: fileUrl,
      FileKey.fileType: fileType.name,
      FileKey.fileName: fileName,
      FileKey.thumbnailStorageId: thumbnailStorageId,
      FileKey.originalFileStorageId: originalFileStorageId,
      FileKey.creationDate: creationDate,
      FileKey.modificationDate: modificationDate,
    };
  }
}