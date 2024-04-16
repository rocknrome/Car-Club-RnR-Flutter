import 'package:flutter/material.dart';
import '../services/trip_service.dart';

class TripDeleteDialog extends StatelessWidget {
  final int tripId;

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
              Navigator.pop(context, true); // Signal deletion success
            });
          },
          child: Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, false); // Cancel deletion
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
