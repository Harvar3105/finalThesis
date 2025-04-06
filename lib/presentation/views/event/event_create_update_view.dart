

import 'dart:developer';

import 'package:final_thesis_app/app/helpers/date_time_to_simple_format_parser.dart';
import 'package:final_thesis_app/app/helpers/validators.dart';
import 'package:final_thesis_app/presentation/views/widgets/fields/custom_text_form_field.dart';
import 'package:final_thesis_app/presentation/views/widgets/fields/duration_picker.dart';
import 'package:final_thesis_app/presentation/views/widgets/navigation/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/domain/event.dart';
import '../../../data/domain/user.dart';
import '../../view_models/event/event_create_update_view_model.dart';
import '../widgets/buttons/date_time_picker.dart';

class EventCreateUpdateView extends ConsumerWidget {
  final Event? editingEvent;
  const EventCreateUpdateView({super.key, this.editingEvent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmAsync = ref.watch(eventCreateUpdateViewModelProvider(event: editingEvent));

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: vmAsync.when(
          data: (friends) {
            final viewModel = ref.read(eventCreateUpdateViewModelProvider(event: editingEvent).notifier);
            log("Friends: $friends");
            log("User: ${viewModel.selectedFriend}");
            return _buildForm(context, viewModel, friends);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, EventCreateUpdateViewModel viewModel, List<User> friends) {
    final spacer = const SizedBox(height: 10);

    return Form(
      key: GlobalKey<FormState>(),
      child: Column(
        children: [
          DropdownButtonFormField<User>(
            decoration: const InputDecoration(labelText: 'Select Friend'),
            value: viewModel.selectedFriend,
            items: friends.map((user) {
              return DropdownMenuItem(
                value: user,
                child: Text('${user.firstName} ${user.lastName}'),
              );
            }).toList(),
            onChanged: (value) => viewModel.selectedFriend = value,
            validator: (value) => value == null ? 'Please select a friend' : null,
          ),
          spacer,
          CustomTextFormField(
            controller: viewModel.titleController,
            labelText: 'Title',
            validator: validateNotEmpty,
          ),
          spacer,
          CustomTextFormField(
            controller: viewModel.descriptionController,
            labelText: 'Description',
            validator: validateNotEmpty,
          ),
          spacer,
          CustomTextFormField(
            controller: viewModel.locationController,
            labelText: 'Location',
            validator: validateNotEmpty,
          ),
          spacer,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Start: ${formatDateTime(viewModel.startTime) ?? 'Not set'}",
                style: Theme.of(context).textTheme.bodySmall,),
              DateTimePicker(onDateSelected: (date) => viewModel.startTime = date, label: 'Start Time'),
            ],
          ),
          spacer,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("End: ${formatDateTime(viewModel.endTime) ?? 'Not set'}",
              style: Theme.of(context).textTheme.bodySmall,),
              DateTimePicker(onDateSelected: (date) => viewModel.endTime = date, label: 'End Time'),
            ],
          ),
          spacer,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Notify before:"),
              DurationPicker(
                initialDuration: viewModel.notifyBefore,
                onDurationSelected: (span) => viewModel.notifyBefore = span,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await viewModel.saveOrUpdateEvent();
              if (success) {
                final router = GoRouter.of(context);
                if (editingEvent == null) {
                  router.pop();
                } else {
                  router.go('/');
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to create event')),
                );
              }
            },
            child: Text(editingEvent == null ? 'Create Event' : 'Update Event'),
          ),
        ],
      ),
    );
  }
}