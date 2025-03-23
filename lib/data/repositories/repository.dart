import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_thesis_app/configurations/firebase/firebase_access_fields.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class Repository<T> {
  final T base;

  Repository(this.base);
}