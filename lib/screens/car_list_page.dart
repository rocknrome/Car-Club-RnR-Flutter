import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'car_show_page.dart';
import 'package:intl/intl.dart';
import '../models/car.dart';
import 'trips_page.dart'; // Make sure this import is correct

class CarListPage extends StatefulWidget {
  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  List<Car> _cars = [];
  final NumberFormat _formatter = NumberFormat('#,##,###');
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final response = await http.get(
          Uri.parse('https://used-car-dealership-be.onrender.com/api/cars/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _cars = data.map<Car>((json) => Car.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error fetching car data: $error';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cool Rides"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    } else if (_cars.isEmpty) {
      return Center(child: Text('No cars found.'));
    } else {
      return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            // Detect swipe left
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TripsPage()));
          }
        },
        child: ListView.builder(
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
                ).then((_) => _fetchData());
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
}
