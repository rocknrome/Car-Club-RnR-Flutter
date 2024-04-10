import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarEditPage extends StatefulWidget {
  final int carId;
  final void Function() refreshCar; // Define the refreshCar callback

  const CarEditPage({Key? key, required this.carId, required this.refreshCar})
      : super(key: key);

  @override
  _CarEditPageState createState() => _CarEditPageState();
}

class _CarEditPageState extends State<CarEditPage> {
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _colorController;

  @override
  void initState() {
    super.initState();
    _makeController = TextEditingController();
    _modelController = TextEditingController();
    _colorController = TextEditingController();

    // Fetch car details and set initial values in form fields
    fetchCarDetails(widget.carId);
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> fetchCarDetails(int carId) async {
    final url = Uri.parse('https://api.example.com/cars/$carId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> carData = jsonDecode(response.body);
      setState(() {
        _makeController.text = carData['make'];
        _modelController.text = carData['model'];
        _colorController.text = carData['color'];
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch car details!'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> _saveChanges(int carId) async {
    final url = Uri.parse('https://api.example.com/cars/$carId');
    final Map<String, dynamic> requestBody = {
      "make": _makeController.text,
      "model": _modelController.text,
      "color": _colorController.text,
    };

    final response = await http.put(
      url,
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Show SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Car details updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      // Call the refreshCar callback to update the data in CarShowPage
      widget.refreshCar();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update car details!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Car ID: ${widget.carId}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextFormField(
              controller: _makeController,
              decoration: InputDecoration(labelText: 'Make'),
            ),
            TextFormField(
              controller: _modelController,
              decoration: InputDecoration(labelText: 'Model'),
            ),
            TextFormField(
              controller: _colorController,
              decoration: InputDecoration(labelText: 'Color'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveChanges(widget.carId);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
