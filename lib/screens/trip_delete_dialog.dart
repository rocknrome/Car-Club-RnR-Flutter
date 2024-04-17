import 'package:flutter/material.dart';
import '../services/trip_service.dart';

class TripDeleteDialog extends StatelessWidget {
  final String tripId;

  const TripDeleteDialog({Key? key, required this.tripId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Deletion'),
      content: Text('Are you sure you want to delete this trip?'),
      actions: [
        TextButton(
          onPressed: () {
            TripService().deleteTrip(tripId).then((_) {
              Navigator.of(context).pop(true); // Pop the dialog
            }).catchError((error) {
              // Handle errors and show a snackbar with the error message
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
    );
  }
}
