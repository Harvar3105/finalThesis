

import 'package:final_thesis_app/app/helpers/validators.dart';
import 'package:final_thesis_app/app/services/providers.dart';
import 'package:final_thesis_app/presentation/views/widgets/buttons/time_picker.dart';
import 'package:final_thesis_app/presentation/views/widgets/fields/custom_text_form_field.dart';
import 'package:final_thesis_app/presentation/views/widgets/fields/duration_picker.dart';
import 'package:final_thesis_app/presentation/views/widgets/navigation/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/typedefs/entity.dart';
import '../../../data/domain/event.dart';
import '../../../data/domain/user.dart';
import '../../view_models/event/event_create_view_model.dart';
import '../widgets/buttons/date_time_picker.dart';

class CreateEventView extends ConsumerStatefulWidget {
  final Event? editingEvent;
  const CreateEventView({super.key, this.editingEvent});

  @override
  _CreateEventViewState createState() => _CreateEventViewState();
}

class _CreateEventViewState extends ConsumerState<CreateEventView> {
  final _formKey = GlobalKey<FormState>();
  Id? _id;
  Id? _firstUserId;
  User? _selectedFriend;
  DateTime? _startTime;
  DateTime? _endTime;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  Duration _notifyBefore = const Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    _titleController.text = '';
    _descriptionController.text = '';
    _locationController.text = '';
  }

  void _asyncLoad() async {
    if (widget.editingEvent != null) {
      _id = widget.editingEvent!.id;
      _firstUserId = widget.editingEvent!.firstUserId;
      _selectedFriend = await ref.read(userServiceProvider).getUserById(widget.editingEvent!.secondUserId) ;
      _startTime = widget.editingEvent!.start;
      _endTime = widget.editingEvent!.end;
      _titleController.text = widget.editingEvent!.title;
      _descriptionController.text = widget.editingEvent!.description;
      _locationController.text = widget.editingEvent!.location;
      _notifyBefore = widget.editingEvent!.notifyBefore ?? const Duration(minutes: 30);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventCreateViewModel = ref.watch(eventCreateViewModelProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: eventCreateViewModel.when(
          data: (friends) {
            _asyncLoad();
            return _buildForm(friends);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }

  Widget _buildForm(List<User> friends) {
    final spacer = const SizedBox(height: 10);

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
          spacer,
          CustomTextFormField(
            controller: _titleController,
            labelText: 'Title',
            validator: validateNotEmpty,
          ),
          spacer,
          CustomTextFormField(
            controller: _descriptionController,
            labelText: 'Description',
            validator: validateNotEmpty,
          ),
          spacer,
          CustomTextFormField(
            controller: _locationController,
            labelText: 'Location',
            validator: validateNotEmpty,
          ),
          spacer,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Start Time: ${_startTime?.toString() ?? 'Not set'}",
              style: Theme.of(context).textTheme.bodySmall,),
              DateTimePicker(onDateSelected: (date) => setState(() => _startTime = date), label: 'Start Time'),
            ],
          ),
          spacer,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("End Time: ${_endTime?.toString() ?? 'Not set'}",
              style: Theme.of(context).textTheme.bodySmall,),
              DateTimePicker(onDateSelected: (date) => setState(() => _endTime = date), label: 'End Time'),
            ],
          ),
          spacer,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Notify before: "),
              DurationPicker(
                initialDuration: _notifyBefore,
                onDurationSelected: (span) => _notifyBefore = span,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(widget.editingEvent == null ? 'Create Event' : 'Update Event'),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = ref.read(eventCreateViewModelProvider.notifier);
      final success = await viewModel.saveOrUpdateEvent(
        id: _id,
        firstUserId: _firstUserId,
        otherUserId: _selectedFriend!.id!,
        start: _startTime!,
        end: _endTime!,
        title: _titleController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        notifyBefore: _notifyBefore,
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