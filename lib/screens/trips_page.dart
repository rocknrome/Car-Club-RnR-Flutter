import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../services/trip_service.dart';
import 'trip_add_page.dart';
import 'trip_details_page.dart';
import 'trip_edit_page.dart';
import 'car_list_page.dart';
import 'contact_page.dart';

class TripsPage extends StatefulWidget {
  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  late Future<List<Trip>> futureTrips;

  @override
  void initState() {
    super.initState();
    _refreshTrips();
  }

  void _refreshTrips() {
    setState(() {
      futureTrips = TripService().fetchTrips();
    });
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rally Chronicles'),
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
      body: _buildTripList(),
    );
  }

  Widget _buildTripList() {
    return FutureBuilder<List<Trip>>(
      future: futureTrips,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          List<Trip> trips = snapshot.data!;
          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              Trip trip = trips[index];
              return Card(
                color: Color.fromARGB(255, 255, 255, 255),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: trip.imageUrl.isNotEmpty
                          ? Image.network(trip.imageUrl,
                              width: 100, height: 100, fit: BoxFit.cover)
                          : Icon(Icons.image, size: 50),
                    ),
                  ),
                  title: Text(trip.title),
                  subtitle: Text(
                    '${trip.description}\nFrom: ${_formatDate(trip.beginDate)} To: ${_formatDate(trip.endDate)}',
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => TripDetailPage(trip: trip)))
                        .then((_) =>
                            _refreshTrips()); // Refresh trips after returning from detail page
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        return Center(child: Text('No trips found.'));
      },
    );
  }
}
