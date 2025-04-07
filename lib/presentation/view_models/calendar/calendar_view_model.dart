
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/services/providers.dart';
import '../../../app/typedefs/e_role.dart';
import '../../../data/domain/event.dart';

part 'calendar_view_model.g.dart';

@riverpod
class CalendarViewModel extends _$CalendarViewModel {
  @override
  Future<List<Event>?> build() async {
    //TODO: somehow need to refresh data after routing
    final eventsService = ref.read(eventServiceProvider);
    final userService = ref.read(userServiceProvider);
    final currentUser = await userService.getCurrentUser();
    if (currentUser == null) {
      state = AsyncValue.error("Current user not found", StackTrace.current);
      return [];
    }

    //TODO: send messages to check previous events processions. If expired by week, set as canceled
    final events = eventsService.getEventsByUserId(currentUser.id!, currentUser.role == ERole.coach);

    return events;
  }
}