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

  Future<void> addTrip(Trip trip) async {
    final response = await http.post(
      Uri.parse('https://car-club-model-2-be.onrender.com/trips'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(trip.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add trip');
    }
  }

  Future<void> updateTrip(String id, Trip updatedTrip) async {
    final response = await http.put(
      Uri.parse('https://car-club-model-2-be.onrender.com/trips/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedTrip.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update trip');
    }
  }

  Future<void> deleteTrip(String id) async {
    final response = await http.delete(
      Uri.parse('https://car-club-model-2-be.onrender.com/trips/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete trip');
    }
  }
}
