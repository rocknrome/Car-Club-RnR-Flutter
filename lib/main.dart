import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:car_club_rocknrome/screens/car_show_page.dart';
import 'package:intl/intl.dart';
import 'screens/trips_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Used Car Dealership',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Car> _cars = [];
  final NumberFormat _formatter =
      NumberFormat('#,##,###'); // Formatter for mileage

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchData(); // Refresh the car list whenever the app comes back to the foreground
    }
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
          Uri.parse('https://used-car-dealership-be.onrender.com/api/cars/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Car> cars =
            data.map((carJson) => Car.fromJson(carJson)).toList();
        setState(() {
          _cars = cars;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching car data: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roman\'s Car Club'),
      ),
      body: _cars.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cars.length,
              itemBuilder: (context, index) {
                final car = _cars[index];
                final formattedMileage = _formatter.format(car.mileage);
                final formattedPrice = '\$${_formatter.format(car.price)}';
                return GestureDetector(
                  onTap: () {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TripsPage()));
        },
        tooltip: 'View Trips',
        child: Icon(Icons.directions_car),
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

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      color: json['color'],
      year: json['year'],
      mileage: json['mileage'],
      price: double.parse(json['price']),
      description: json['description'],
      photoUrl: json['photo_url'],
    );
  }
}
