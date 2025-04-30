
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/services/providers.dart';
import '../../../app/typedefs/e_role.dart';
import '../../../data/domain/event.dart';
import '../../../data/domain/user.dart';

part 'calendar_view_model.g.dart';

@riverpod
class CalendarViewModel extends _$CalendarViewModel {
  @override
  Future<List<Event>?> build(User? user) async {
    final eventsService = ref.read(eventServiceProvider);
    var currentUser = user;
    if (user == null) {
      final userService = ref.read(userServiceProvider);
      currentUser = await userService.getCurrentUser();
    }

    if (currentUser == null) {
      state = AsyncValue.error("Current user not found", StackTrace.current);
      return [];
    }

    //TODO: send messages to check previous events processions. If expired by week, set as canceled
    final events = eventsService.getEventsByUserId(currentUser.id!, currentUser.role == ERole.coach);

    return events;
  }
}