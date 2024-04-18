import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../services/trip_service.dart';

class TripEditPage extends StatefulWidget {
  final Trip trip;

  const TripEditPage({Key? key, required this.trip}) : super(key: key);

  @override
  _TripEditPageState createState() => _TripEditPageState();
}

class _TripEditPageState extends State<TripEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _beginDateController;
  late TextEditingController _endDateController;
  late TextEditingController _participantsController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.trip.title);
    _descriptionController =
        TextEditingController(text: widget.trip.description);
    _beginDateController =
        TextEditingController(text: widget.trip.beginDate.toString());
    _endDateController =
        TextEditingController(text: widget.trip.endDate.toString());
    _participantsController =
        TextEditingController(text: widget.trip.participants.join(', '));
    _imageUrlController = TextEditingController(text: widget.trip.imageUrl);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _beginDateController.dispose();
    _endDateController.dispose();
    _participantsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges(String tripId) async {
    if (tripId.isEmpty) {
      print('Trip ID is empty');
      return;
    }

    final updatedTrip = Trip(
      id: tripId,
      title: _titleController.text,
      description: _descriptionController.text,
      beginDate: DateTime.parse(_beginDateController.text),
      endDate: DateTime.parse(_endDateController.text),
      participants:
          _participantsController.text.split(',').map((e) => e.trim()).toList(),
      imageUrl: _imageUrlController.text,
      createdAt: widget.trip.createdAt,
      updatedAt: DateTime.now(),
    );

    await TripService().updateTrip(tripId, updatedTrip);

    Navigator.pop(context, true); // Return true to indicate changes were saved
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Trip'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _beginDateController,
              decoration: InputDecoration(labelText: 'Begin Date'),
            ),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: 'End Date'),
            ),
            TextField(
              controller: _participantsController,
              decoration:
                  InputDecoration(labelText: 'Participants (comma-separated)'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveChanges(widget.trip.id);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
