import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';
import '../services/trip_service.dart';
import 'trips_page.dart';

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

  final DateFormat dateFormat = DateFormat('MM-dd-yyyy');

  Future<void> _addTrip(BuildContext context) async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    final DateTime beginDate =
        dateFormat.parse(_beginDateController.text.trim());
    final DateTime endDate = dateFormat.parse(_endDateController.text.trim());
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

    await TripService().addTrip(newTrip);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Trip added successfully'),
      ),
    );

    // Navigate back to the trip list
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TripsPage()),
    );
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
              decoration: InputDecoration(labelText: 'Begin Date (MM-dd-yyyy)'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: 'End Date (MM-dd-yyyy)'),
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
              onPressed: () => _addTrip(context),
              child: Text('Add Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
