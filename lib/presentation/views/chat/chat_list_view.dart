import 'dart:developer';

import 'package:final_thesis_app/presentation/view_models/chat/chat_list_view_model.dart';
import 'package:final_thesis_app/presentation/views/widgets/animations/empty_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../configurations/strings.dart';
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
                user != null && lastMessage != null ? "${user.firstName} ${user.lastName}: $lastMessage"
                : "No messages yet...",
                maxLines: 1,
                overflow: TextOverflow.ellipsis
              ),
              leading: CircleAvatar(
                backgroundImage: user?.avatarUrl != null
                    ? NetworkImage(user!.avatarUrl!)
                    : const AssetImage("assets/images/user_icon.png") as ImageProvider,
              ),
              trailing: ElevatedButton(
                onPressed: () async {
                  GoRouter.of(context).pushNamed(Strings.chat, extra: chat);
                },
                child: Icon(Icons.chat_bubble_outline, size: 20, color: Theme.of(context).iconTheme.color)
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