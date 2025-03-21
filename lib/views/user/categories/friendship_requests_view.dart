import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/models/domain/user.dart';
import '../../../app/storage/user/combined/combined_user.dart';
import '../../../configurations/firebase/firebase_access_fields.dart';
import '../../widgets/animations/animation_with_text.dart';
import '../../widgets/animations/error_animation.dart';
import '../../widgets/animations/loading/loading_animation.dart';

class FriendshipRequestsView extends ConsumerWidget {
  const FriendshipRequestsView({super.key, required this.users});
  final List<User>? users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomingRequestsAsync = ref.watch(combinedUserProvider(FirebaseFields.friendRequests));
    final sentRequestsAsync = ref.watch(combinedUserProvider(FirebaseFields.sentFriendRequests));

    log("1");

    return incomingRequestsAsync.when(
      data: (data) {
        log("2");
        return sentRequestsAsync.when(
            data: (data2){
              log("3");
              return Container();
            },
          loading: () => const AnimationWithText(animation: LoadingAnimationView(), text: 'Loading sent requests...'),
          error: (error, stackTrace) {
            log('FriendsListView: Error occurred: $error, at $stackTrace');
            return AnimationWithText(
                animation: ErrorAnimationView(), text: 'Oops! An error occurred.');
          },
        );
      },
      loading: () => const AnimationWithText(animation: LoadingAnimationView(), text: 'Loading requests...'),
      error: (error, stackTrace) {
        log('FriendsListView: Error occurred: $error, at $stackTrace');
        return AnimationWithText(
            animation: ErrorAnimationView(), text: 'Oops! An error occurred.');
      },
    );

  }
}