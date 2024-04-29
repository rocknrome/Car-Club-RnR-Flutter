import 'package:flutter/material.dart';
import '../services/trip_service.dart';

class TripDeleteDialog extends StatelessWidget {
  final String tripId;
  final Function(bool) onDelete;

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
          onPressed: () => _deleteTrip(context),
          child: Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            onDelete(false);
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  void _deleteTrip(BuildContext context) {
    TripService().deleteTrip(tripId).then((_) {
      onDelete(true);
      Navigator.of(context).pop(); // Ensure the dialog is popped first
      Future.delayed(Duration(milliseconds: 300), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Trip deleted successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }).catchError((error) {
      Navigator.of(context).pop();
      Future.delayed(Duration(milliseconds: 300), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete trip: $error'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    });
  }
}
