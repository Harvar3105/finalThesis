import 'package:flutter/material.dart';

import '../../../data/domain/event.dart';

class EventView extends StatelessWidget {
  final Event event;

  const EventView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date: ${event.start.toLocal()} - ${event.end.toLocal()}',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 10),
          Text('Place: ${event.location}',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          Text('Description:',
              style: Theme.of(context).textTheme.titleMedium),
          Text(event.description,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          if (event.notifyBefore != null)
            Text('Remind before: ${event.notifyBefore!.inMinutes} minutes',
                style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
