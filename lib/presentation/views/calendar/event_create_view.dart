

import 'package:final_thesis_app/presentation/views/widgets/buttons/time_picker.dart';
import 'package:final_thesis_app/presentation/views/widgets/navigation/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/domain/user.dart';
import '../../view_models/calendar/event_create_view_model.dart';
import '../widgets/buttons/date_time_picker.dart';

class CreateEventView extends ConsumerStatefulWidget {
  final DateTime selectedDay;
  const CreateEventView({super.key, required this.selectedDay});

  @override
  _CreateEventViewState createState() => _CreateEventViewState();
}

class _CreateEventViewState extends ConsumerState<CreateEventView> {
  final _formKey = GlobalKey<FormState>();
  User? _selectedFriend;
  DateTime? _startTime;
  DateTime? _endTime;
  String _title = '';
  String _description = '';
  String _location = '';
  Duration? _notifyBefore;

  @override
  Widget build(BuildContext context) {
    final eventCreateViewModel = ref.watch(eventCreateViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: eventCreateViewModel.when(
          data: (friends) => _buildForm(friends),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }

  Widget _buildForm(List<User> friends) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField<User>(
            decoration: const InputDecoration(labelText: 'Select Friend'),
            value: _selectedFriend,
            items: friends.map((user) {
              return DropdownMenuItem(
                value: user,
                child: Text(user.firstName + ' ' + user.lastName),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedFriend = value),
            validator: (value) => value == null ? 'Please select a friend' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Title'),
            onChanged: (value) => _title = value,
            validator: (value) => value!.isEmpty ? 'Enter a title' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            onChanged: (value) => _description = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Location'),
            onChanged: (value) => _location = value,
          ),
          DateTimePicker(onDateSelected: (date) => setState(() => _startTime = date), label: 'Start Time'),
          DateTimePicker(onDateSelected: (date) => setState(() => _endTime = date), label: 'End Time'),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Create Event'),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = ref.read(eventCreateViewModelProvider.notifier);
      final success = await viewModel.createEvent(
        _selectedFriend!.id!,
        _startTime!,
        _endTime!,
        _title,
        _description,
        _location,
        _notifyBefore,
      );
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create event')),
        );
      }
    }
  }
}