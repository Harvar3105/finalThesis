import 'dart:developer';

import 'package:final_thesis_app/presentation/view_models/event/event_view_model.dart';
import 'package:final_thesis_app/presentation/views/widgets/locations/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/typedefs/e_event_privacy.dart';
import '../../../configurations/strings.dart';
import '../../../data/domain/event.dart';

class EventView extends ConsumerWidget {
  final Event event;
  final bool isOverlapping;

  const EventView({super.key, required this.event, required this.isOverlapping});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(eventViewModelProvider);
    final viewModel = ref.read(eventViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: currentUser.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          final isPrivate = event.privacy == EEventPrivacy.private;
          final isCreator = event.creatorId == user.id;
          final isAttendee = isCreator || event.friendId == user.id;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${event.start.toLocal()} - ${event.end.toLocal()}',
                  style: theme.textTheme.bodyLarge),
              const SizedBox(height: 10),
              AddressProvider(location: event.location),
              const SizedBox(height: 10),
              Text('Description:',
                  style: theme.textTheme.titleMedium),
              Text(event.description,
                  style: theme.textTheme.bodyMedium),
              const SizedBox(height: 20),
              if (event.notifyBefore != null)
                Text('Remind before: ${event.notifyBefore!.inMinutes} minutes',
                    style: theme.textTheme.bodySmall),
              if (isOverlapping)
                Text('This event overlaps with another event.',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.red)),
              const SizedBox(height: 20),
              if (!isPrivate && isAttendee)
              isCreator ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final deletion = await viewModel.deleteEvent(event);
                        if (deletion) {
                          GoRouter.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.delete_forever, color: Colors.red, size: 45,),
                    ),
                    IconButton(
                        onPressed: () => GoRouter.of(context).replaceNamed(Strings.addEvent, extra: [event, false]),
                        icon: const Icon(Icons.edit_rounded, color: Colors.yellow, size: 45,),
                    ),
                  ],
                )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: (){log("pressed Cancel");},
                      icon: const Icon(Icons.delete_forever, color: Colors.red, size: 45,)
                  ),
                  IconButton(
                      onPressed: () => GoRouter.of(context).replaceNamed(Strings.addEvent, extra: [event, true]),
                      icon: const Icon(Icons.compare_arrows_outlined, color: Colors.amberAccent, size: 45,)
                  ),
                  IconButton(
                      onPressed: (){log("pressed Accept");},
                      icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 45,)
                  ),
                ],
              )
            ],
          );
        },
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(error.toString())),
      )
    );
  }
}
