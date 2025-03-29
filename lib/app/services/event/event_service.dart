import '../../../data/domain/event.dart';
import '../../../data/repositories/event/event_storage.dart';

class EventService {
  final EventStorage _eventService;

  EventService(this._eventService);

  Future<Event?> getEventById(String id) async {
    return (await _eventService.getEventById(id))?.eventFromPayload();
  }

  Future<List<Event>?> getEventsByDate(DateTime date) async {
    return (await _eventService.getEventsByDate(date))
        ?.map((event) => event.eventFromPayload())
        .whereType<Event>()
        .toList();
  }

  Future<List<Event>?> getAllEvents() async {
    return (await _eventService.getAllEvents())
        ?.map((event) => event.eventFromPayload())
        .whereType<Event>()
        .toList();
  }

  Future<List<Event>?> getEventsByUserId(String userId, bool isCoach) async {
    return (await _eventService.getEventsByUserId(userId, isCoach))
        ?.map((event) => event.eventFromPayload())
        .whereType<Event>()
        .toList();
  }

  Future<bool> saveOrUpdateEvent(Event event) async {
    return await _eventService.saveOrUpdateEvent(EventPayload().eventToPayload(event));
  }

  Future<bool> deleteEvent(Event event) async {
    return await _eventService.deleteEvent(EventPayload().eventToPayload(event));
  }
}