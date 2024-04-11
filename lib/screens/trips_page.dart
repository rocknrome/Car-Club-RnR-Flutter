import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../services/trip_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips'),
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
                        ? Image.network(trip.imageUrl, width: 100, fit: BoxFit.cover)
                        : Icon(Icons.image, size: 50),
                    title: Text(trip.title),
                    subtitle: Text(
                      '${trip.description}\nFrom: ${trip.beginDate.toLocal()} To: ${trip.endDate.toLocal()}',
                    ),
                    isThreeLine: true,
                    trailing: Text('${trip.participants.length} participants'),
                    onTap: () {
                      // Implement navigation or action on tap
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
