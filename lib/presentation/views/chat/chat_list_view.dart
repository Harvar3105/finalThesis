import 'dart:developer';

import 'package:final_thesis_app/presentation/view_models/chat/chat_list_view_model.dart';
import 'package:final_thesis_app/presentation/views/widgets/animations/empty_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/animations/animation_with_text.dart';
import '../widgets/animations/error_animation.dart';
import '../widgets/animations/loading/loading_animation.dart';

class ChatListView extends ConsumerWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(chatListViewModelProvider);

    return dataAsync.when(
      data: (data) {
        if (data == null) {
          return const Center(
            child: AnimationWithText(animation: EmptyAnimationView(), text: "Sorry! No chats were found :("),
          );
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final chat = data[index].$1;
            final lastMessage = data[index].$2;
            final user = data[index].$3;
            return ListTile(
              title: Text(chat.name),
              subtitle: Text(
                "${user?.firstName} ${user?.lastName}: $lastMessage",
                maxLines: 1,
                overflow: TextOverflow.ellipsis
              ),
              leading: CircleAvatar(
                child: Text(chat.name.isNotEmpty ? chat.name[0] : '?'),
              ),
            );
          },
        );
      },
      loading: () => const AnimationWithText(
          animation: LoadingAnimationView(), text: 'Loading chats...'),
      error: (error, stackTrace) {
        log('ChatsListView: Error occurred: $error, at $stackTrace');
        return AnimationWithText(
            animation: ErrorAnimationView(), text: 'Oops! An error occurred.');
      },
    );
  }
  
}