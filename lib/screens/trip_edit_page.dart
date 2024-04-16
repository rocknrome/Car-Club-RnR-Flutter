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

  // Add more controllers here

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.trip.title);
    _descriptionController =
        TextEditingController(text: widget.trip.description);
    // Initialize controllers for extra fields
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Trip'),
      ),
      body: Padding(
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
            // Add more form fields here
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Update and save the edited trip
                Trip updatedTrip = Trip(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  beginDate: widget.trip.beginDate,
                  endDate: widget.trip.endDate,
                  participants: widget.trip.participants,
                );
                int id = widget.trip.id ??
                    0; // Provide a default value or handle null case
                TripService().updateTrip(id, updatedTrip).then((_) {
                  Navigator.pop(
                      context); // Navigate back to the trips page after updating the trip
                });
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
