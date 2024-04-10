import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarShowPage extends StatefulWidget {
  final int carId;

  const CarShowPage({Key? key, required this.carId}) : super(key: key);

  @override
  _CarShowPageState createState() => _CarShowPageState();
}

class _CarShowPageState extends State<CarShowPage> {
  late Future<Map<String, dynamic>> _futureCar;

  @override
  void initState() {
    super.initState();
    _futureCar = fetchCar(widget.carId);
  }

  Future<Map<String, dynamic>> fetchCar(int carId) async {
    final response = await http.get(Uri.parse(
        'https://used-car-dealership-be.onrender.com/api/cars/$carId/'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load car');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureCar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final car = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(car['photo_url']),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '${car['make']} ${car['model']}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Color: ${car['color']}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Year: ${car['year']}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Mileage: ${car['mileage']} miles',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Price: \$${car['price']}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to edit car page
                      },
                      child: Text('Edit Car'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Delete car
                      },
                      child: Text('Delete Car'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back to list'),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
