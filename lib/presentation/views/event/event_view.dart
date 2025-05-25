import 'dart:developer';

import 'package:final_thesis_app/presentation/view_models/event/event_view_model.dart';
import 'package:final_thesis_app/presentation/views/widgets/locations/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/typedefs/e_event_privacy.dart';
import '../../../app/typedefs/e_event_type.dart';
import '../../../configurations/app_colours.dart';
import '../../../configurations/strings.dart';
import '../../../data/domain/event.dart';

class EventView extends ConsumerWidget {
  final Event event;
  final bool isOverlapping;

  const EventView({super.key, required this.event, required this.isOverlapping});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final users = ref.watch(eventViewModelProvider(event));
    final viewModel = ref.read(eventViewModelProvider(event).notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: users.when(
        data: (data) {
          if (data == null || data.$1 == null) {
            return const Center(child: Text('User not found'));
          }

          log("Data: $data");
          final currentUser = data.$1!;
          final attendee = data.$2;
          final creator = data.$3!;

          final isPrivate = event.privacy == EEventPrivacy.private;
          final isCreator = event.creatorId == currentUser.id;
          final isAttendee = isCreator || event.friendId == currentUser.id;

          final formattedStart = DateFormat('dd.MM.yy - HH:mm').format(event.start.toLocal());
          final formattedEnd = DateFormat('dd.MM.yy - HH:mm').format(event.end.toLocal());

          final borderColour = isOverlapping ? Colors.red.shade500
              : switch (event.type) {
            EEventType.declared => Colors.grey,
            EEventType.shadow => Colors.blueGrey,
            EEventType.accepted => Colors.green,
            EEventType.canceled => Colors.red,
            EEventType.conterOffered => Colors.amberAccent,
            EEventType.processed => Colors.blueGrey.withAlpha(125),
          };

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: AppColors.darkGrayBackground,
                  borderRadius: BorderRadius.circular(30),
                  border: Border(
                  top: BorderSide(color: borderColour, width: 5),
                  bottom: BorderSide(color: borderColour, width: 5),
                  left: BorderSide(color: borderColour, width: 5),
                  right: BorderSide(color: borderColour, width: 5)
              )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Title: ${event.title}",
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  Text('Start: $formattedStart',
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  Text('End: $formattedEnd',
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  if (event.privacy != EEventPrivacy.private)
                    Text('Attendee: ${attendee?.firstName} ${attendee?.lastName}',
                        style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 10),
                  Text('Creator: ${creator.firstName} ${creator.lastName}',
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  AddressProvider(location: event.location),
                  const SizedBox(height: 10),
                  Text('Description:\n${event.description}',
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  if (event.notifyBefore != null)
                    Text('Remind before: ${event.notifyBefore!.inMinutes} minutes',
                        style: theme.textTheme.bodySmall),
                  if (isOverlapping)
                    Text('This event overlaps with another event.',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.red)),
                  const SizedBox(height: 20),
                  if ((!isPrivate && isAttendee) ||(isPrivate && isCreator))
                  isCreator ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () async {
                            final deletion = await viewModel.deleteEvent(event);
                            if (deletion) {
                              GoRouter.of(context).pop(true);
                            }
                          },
                          icon: const Icon(Icons.delete_forever, color: Colors.red, size: 45,),
                        ),
                        IconButton(
                            onPressed: () => GoRouter.of(context).pushNamed(Strings.addEvent, extra: [event, false]),
                            icon: const Icon(Icons.edit_rounded, color: Colors.yellow, size: 45,),
                        ),
                      ],
                    )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (event.type == EEventType.declared) {
                              viewModel.makeDecision(event, false);
                            } else {
                              viewModel.deleteEvent(event);
                            }
                            GoRouter.of(context).pop(true);
                          },
                          icon: const Icon(Icons.delete_forever, color: Colors.red, size: 45,)
                      ),
                      IconButton(
                          onPressed: () => GoRouter.of(context).pushNamed(Strings.addEvent, extra: [event, true]),
                          icon: const Icon(Icons.compare_arrows_outlined, color: Colors.amberAccent, size: 45,)
                      ),
                      IconButton(
                          onPressed: () {
                            viewModel.makeDecision(event, true);
                            GoRouter.of(context).pop(true);
                          },
                          icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 45,)
                      ),
                    ],
                  )
                ],
              ),
            ),
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
