import '../typedefs/entity.dart';
import 'entity.dart';
import 'event.dart';

class Calendar extends Entity {
  final Id? ownerId;
  List<Event> events = [];
  DateTime now = DateTime.now();


  Calendar({
    super.id,
    this.ownerId
  });
}