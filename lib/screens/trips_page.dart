import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../services/trip_service.dart';
import 'trip_add_page.dart';
import 'trip_edit_page.dart';
import 'trip_delete_dialog.dart';
import 'trip_details_page.dart';

class TripsPage extends StatefulWidget {
  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  late Future<List<Trip>> futureTrips;

  @override
  void initState() {
    super.initState();
    futureTrips = TripService().fetchTrips();
  }

  void _refreshTrips() {
    setState(() {
      futureTrips = TripService().fetchTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TripAddPage()),
              ).then((_) => _refreshTrips());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Trip>>(
        future: futureTrips,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Trip> trips = snapshot.data!;
            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                Trip trip = trips[index];
                return Card(
                  child: ListTile(
                    leading: trip.imageUrl.isNotEmpty
                        ? Image.network(trip.imageUrl,
                            width: 100, fit: BoxFit.cover)
                        : Icon(Icons.image, size: 50),
                    title: Text(trip.title),
                    subtitle: Text(
                      '${trip.description}\nFrom: ${trip.beginDate.toLocal()} To: ${trip.endDate.toLocal()}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripEditPage(trip: trip),
                              ),
                            ).then((_) => _refreshTrips());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  TripDeleteDialog(tripId: trip.id!),
                            ).then((result) {
                              if (result == true) {
                                _refreshTrips(); // Refresh after deletion
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TripDetailPage(trip: trip),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
