import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip.dart';

class TripService {
  Future<List<Trip>> fetchTrips() async {
    final response = await http
        .get(Uri.parse('https://car-club-model-2-be.onrender.com/trips'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Trip> trips =
          body.map((dynamic item) => Trip.fromJson(item)).toList();
      return trips;
    } else {
      throw Exception('Failed to load trips');
    }
  }
}
