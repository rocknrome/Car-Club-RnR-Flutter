import 'dart:convert'; // Import convert for jsonDecode
import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../services/trip_service.dart';

class TripAddPage extends StatefulWidget {
  @override
  _TripAddPageState createState() => _TripAddPageState();
}

class _TripAddPageState extends State<TripAddPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _beginDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _beginPointController = TextEditingController();
  final TextEditingController _endPointController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  Future<void> _addTrip() async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    final DateTime beginDate = DateTime.parse(_beginDateController.text.trim());
    final DateTime endDate = DateTime.parse(_endDateController.text.trim());
    final List<String> participants =
        _participantsController.text.split(',').map((e) => e.trim()).toList();
    final String imageUrl = _imageUrlController.text.trim();

    final Trip newTrip = Trip(
      id: '',
      title: title,
      description: description,
      beginDate: beginDate,
      endDate: endDate,
      participants: participants,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Call the TripService to add the new trip
    await TripService().addTrip(newTrip);

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Trip'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _beginDateController,
              decoration: InputDecoration(labelText: 'Begin Date'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: 'End Date'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _participantsController,
              decoration:
                  InputDecoration(labelText: 'Participants (comma-separated)'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _beginPointController,
              decoration: InputDecoration(labelText: 'Begin Point (JSON)'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _endPointController,
              decoration: InputDecoration(labelText: 'End Point (JSON)'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _addTrip,
              child: Text('Add Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
