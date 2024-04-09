import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:car_club_rocknrome/screens/car_show_page.dart';
import 'splash_screen.dart';

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
      home: const SplashScreen(),
      routes: {
        '/carShow': (context) => CarShowPage(
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
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/carShow', arguments: car.id);
                  },
                  child: Card(
                    child: ListTile(
                      leading: Image.network(car.photoUrl),
                      title: Text('${car.make} ${car.model}'),
                      subtitle: Text(
                          'Color: ${car.color}\nYear: ${car.year}\nMileage: ${car.mileage} miles\nPrice: \$${car.price.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          // Handle onPressed event if needed
                        },
                      ),
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
