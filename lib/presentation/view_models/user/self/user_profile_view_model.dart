
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/services/providers.dart';
import '../../../../data/domain/user.dart';

part 'user_profile_view_model.g.dart';

@riverpod
class UserProfileViewModel extends _$UserProfileViewModel {
  late User? currentUser;
  late User? selectedUser;
  late bool isCurrentUser;
  late int processedEventsCount = 0;

  @override
  FutureOr<User?> build({User? outerUser}) async {
    log("${outerUser?.firstName} ${outerUser?.lastName}");
    final userService = ref.watch(userServiceProvider);
    currentUser = await userService.getCurrentUser();
    selectedUser = outerUser;

    processedEventsCount = await getProcessedEventsCount();

    if (outerUser != null) {
      isCurrentUser = false;
      return outerUser;
    } else {
      isCurrentUser = true;
      if (currentUser != null) {
        return currentUser!;
      } else {
        state = AsyncValue.error("Current user is not defined", StackTrace.current);
      }
    }
    return null;
  }

  FutureOr<int> getProcessedEventsCount() async {
    if (selectedUser == null || currentUser == null) {
      return 0;
    }
    final eventService = ref.watch(eventServiceProvider);
    return await eventService.getProcessedEventCountByUserPair(selectedUser!.id!, currentUser!.id!);
  }
}