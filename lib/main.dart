import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:car_club_rocknrome/screens/car_show_page.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Used Car Dealership',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        '/carShow': (context) => const CarShowPage(
            carId: 0), // Initially passing 0, replace it with actual car ID
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Car> _cars = [];
  final NumberFormat _formatter =
      NumberFormat('#,##,###'); // Formatter for mileage

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
          Uri.parse('https://used-car-dealership-be.onrender.com/api/cars/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Car> cars = data
            .map((carJson) => Car(
                  id: carJson['id'],
                  make: carJson['make'],
                  model: carJson['model'],
                  color: carJson['color'],
                  year: carJson['year'],
                  mileage: carJson['mileage'],
                  price: double.parse(carJson['price']),
                  description: carJson['description'],
                  photoUrl: carJson['photo_url'],
                ))
            .toList();
        setState(() {
          _cars = cars;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // Handle error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Used Car Dealership'),
      ),
      body: _cars.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cars.length,
              itemBuilder: (context, index) {
                final car = _cars[index];
                final formattedMileage =
                    _formatter.format(car.mileage); // Format mileage
                final formattedPrice =
                    '\$${_formatter.format(car.price)}'; // Format price
                return GestureDetector(
                  onTap: () {
                    // Handle onTap event to navigate to the show page with the correct URL
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarShowPage(carId: car.id),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      leading: Image.network(car.photoUrl),
                      title: Text('${car.make} ${car.model}'),
                      subtitle: Text(
                          'Color: ${car.color}\nYear: ${car.year}\nMileage: $formattedMileage miles\nPrice: $formattedPrice'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class Car {
  final int id;
  final String make;
  final String model;
  final String color;
  final int year;
  final int mileage;
  final double price;
  final String description;
  final String photoUrl;

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.color,
    required this.year,
    required this.mileage,
    required this.price,
    required this.description,
    required this.photoUrl,
  });
}
