import 'dart:developer';

import 'package:final_thesis_app/data/domain/chat.dart';
import 'package:final_thesis_app/data/domain/message.dart';
import 'package:final_thesis_app/presentation/views/widgets/messages/message_buuble.dart';
import 'package:final_thesis_app/presentation/views/widgets/navigation/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view_models/chat/chat_view_model.dart';
import '../widgets/animations/animation_with_text.dart';
import '../widgets/animations/error_animation.dart';
import '../widgets/animations/loading/loading_animation.dart';

class ChatView extends ConsumerStatefulWidget {
  final Chat chat;

  const ChatView({super.key, required this.chat});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  List<Message> _previousMessages = [];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final modelReady = ref.watch(chatViewModelProvider(widget.chat));


    return modelReady.when(
      data: (ready) {
        final viewModel = ref.read(chatViewModelProvider(widget.chat).notifier);

        return StreamBuilder<List<Message>>(
          stream: viewModel.messagesStream,
          builder: (context, snapshot) {
            final messages = snapshot.data ?? [];


            if (_previousMessages.length != messages.length) {
              _previousMessages = List.from(messages);
              _scrollToBottom();
            }

            return Scaffold(
              appBar: CustomAppBar(),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: messages.map((msg) => MessageBubble(message: msg, currentUserId: viewModel.currentUser.id!).build(context)).toList(),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Type message...',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          final text = _textController.text.trim();
                          if (text.isEmpty) return;

                          await viewModel.sendMessage(text, viewModel.currentUser.id!);
                          _textController.clear();
                          _scrollToBottom();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const AnimationWithText(
          animation: LoadingAnimationView(), text: 'Loading chat...'),
      error: (error, stackTrace) {
        log('ChatView: Error occurred: $error, at $stackTrace');
        return AnimationWithText(
            animation: ErrorAnimationView(), text: 'Oops! An error occurred.');
      },
    );

  }
}