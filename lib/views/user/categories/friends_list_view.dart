
import 'dart:developer';

import 'package:final_thesis_app/app/storage/user/combined/combined_user.dart';
import 'package:final_thesis_app/configurations/firebase/firebase_access_fields.dart';
import 'package:final_thesis_app/views/widgets/animations/animation_with_text.dart';
import 'package:final_thesis_app/views/widgets/animations/error_animation.dart';
import 'package:final_thesis_app/views/widgets/animations/loading/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/models/domain/user.dart';

class FriendsListView extends ConsumerWidget {
  const FriendsListView({super.key, required this.users});
  final List<User>? users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combinedAsync = ref.watch(combinedUserProvider(FirebaseFields.friends));

    return combinedAsync.when(
      data: (data) {
        final user = data.$1;
        final friends = data.$2;
        log('FriendsListView: Got user $user and friends $friends');

        if (friends.isEmpty) {
          return const Center(
            child: Text('Oops! You have no friends yet. Why not find some?\n:)'),
          );
        }

        return Column(
          children: [
            SingleChildScrollView(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (BuildContext context, int index) {
                  final friend = friends[index];
                  return ListTile(
                    title: Text(friend.firstName),
                    subtitle: Text(friend.email),
                    leading: CircleAvatar(
                      child: Text(friend.lastName.isNotEmpty
                          ? friend.lastName[0]
                          : '?'),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const AnimationWithText(animation: LoadingAnimationView(), text: 'Loading friends...'),
      error: (error, stackTrace) {
        log('FriendsListView: Error occurred: $error, at $stackTrace');
        return AnimationWithText(
            animation: ErrorAnimationView(), text: 'Oops! An error occurred.');
      },
    );
  }
}
