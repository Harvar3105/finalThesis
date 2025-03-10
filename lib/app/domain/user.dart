import 'package:final_thesis_app/app/domain/entity.dart';


class User extends Entity {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? email;
  final String? avatarUrl;

  User({
    super.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    this.avatarUrl,
  });
}