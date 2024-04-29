import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'car_show_page.dart';
import 'package:intl/intl.dart';
import '../models/car.dart';

class CarListPage extends StatefulWidget {
  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  List<Car> _cars = [];
  final NumberFormat _priceFormatter =
      NumberFormat('#,##0', 'en_US'); // For mileage
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
      backgroundColor: Colors.grey[300],
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
      return ListView.builder(
        itemCount: _cars.length,
        itemBuilder: (context, index) {
          final car = _cars[index];
          final formattedMileage = _priceFormatter.format(car.mileage);
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
              color: Color.fromARGB(255, 255, 255, 255),
              child: ListTile(
                leading: Hero(
                  tag: 'car_photo_${car.id}',
                  child: Container(
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
                      child: Image.network(car.photoUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
                title: Text('${car.make} ${car.model}'),
                subtitle: Text(
                    'Color: ${car.color}\nYear: ${car.year}\nMileage: $formattedMileage miles'),
              ),
            ),
          );
        },
      );
    }
  }
}
