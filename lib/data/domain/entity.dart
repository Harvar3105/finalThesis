import '../../app/typedefs/entity.dart';

abstract class Entity {
  late final Id? id;
  late final DateTime createdAt;
  late final DateTime updatedAt;

  Entity({this.id, DateTime? createdAt, DateTime? updatedAt})
      : createdAt = createdAt ?? DateTime.now().toUtc(),
        updatedAt = updatedAt ?? DateTime.now().toUtc();

}