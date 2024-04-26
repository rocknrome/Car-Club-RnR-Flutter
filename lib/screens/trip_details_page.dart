import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';
import '../services/trip_service.dart';
import 'trip_add_page.dart';
import 'trip_edit_page.dart';

class TripDetailPage extends StatelessWidget {
  final Trip trip;

  const TripDetailPage({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'trip_${trip.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: trip.imageUrl.isNotEmpty
                    ? Image.network(trip.imageUrl,
                        width: double.infinity, fit: BoxFit.cover)
                    : SizedBox(
                        height: 200,
                        child: Icon(Icons.image, size: 200),
                      ),
              ),
            ),
            SizedBox(height: 16),
            Text('${trip.title}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('${trip.description}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Started:   ${formatter.format(trip.beginDate)}'),
            Text('Finished: ${formatter.format(trip.endDate)}'),
            SizedBox(height: 8),
            Text('Participants:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: trip.participants.map((name) => Text(name)).toList(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripEditPage(trip: trip),
                      ),
                    ).then((_) =>
                        Navigator.of(context).pop()); // Refresh after edit
                  },
                  child: Text('Edit Trip'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showDeleteDialog(context, trip.id);
                  },
                  child: Text('Delete Trip'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripAddPage(),
                      ),
                    );
                  },
                  child: Text('Add New Trip'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String tripId) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this trip?'),
        actions: [
          TextButton(
            onPressed: () {
              TripService().deleteTrip(tripId).then((_) {
                Navigator.of(context).pop(true); // Pop the dialog
                Navigator.of(context)
                    .pop(true); // Optionally pop the detail page
              }).catchError((error) {
                // Handle errors and show a snackbar with the error message
                Navigator.of(context).pop(false);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete trip: $error')));
              });
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
