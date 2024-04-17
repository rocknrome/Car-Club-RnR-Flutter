import 'package:flutter/material.dart';
import '../services/trip_service.dart';

class TripDeleteDialog extends StatelessWidget {
  final String tripId;
  final Function(bool) onDelete; // Callback function to handle delete result

  const TripDeleteDialog(
      {Key? key, required this.tripId, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Deletion'),
      content: Text('Are you sure you want to delete this trip?'),
      actions: [
        TextButton(
          onPressed: () {
            TripService().deleteTrip(tripId).then((_) {
              onDelete(true); // Notifying parent widget of successful deletion
              Navigator.of(context).pop(); // Pop the dialog
            }).catchError((error) {
              // Handle errors and show a snackbar with the error message
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete trip: $error')));
            });
          },
          child: Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            onDelete(false); // Notify parent widget of cancellation
            Navigator.of(context).pop(); // Pop the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
