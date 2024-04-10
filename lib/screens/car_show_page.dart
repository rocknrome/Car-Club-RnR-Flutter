import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'car_edit_page.dart';

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

  Future<void> _deleteCar() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this car?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm deletion
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel deletion
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );

    if (confirmed != null && confirmed) {
      final response = await http.delete(
        Uri.parse(
            'https://used-car-dealership-be.onrender.com/api/cars/${widget.carId}/'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Car deleted successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context); // Redirect to main page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete car!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CarEditPage(carId: widget.carId),
                          ),
                        );
                      },
                      child: Text('Edit Car'),
                    ),
                    ElevatedButton(
                      onPressed: _deleteCar, // Call _deleteCar method
                      child: Text('Delete Car'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarEditPage(
                                carId:
                                    0), // Pass 0 as carId for adding a new car
                          ),
                        );
                      },
                      child: Text('Add Car'),
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
