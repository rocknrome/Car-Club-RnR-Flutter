import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCarPage extends StatefulWidget {
  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State {
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _colorController;
  late TextEditingController _yearController;
  late TextEditingController _mileageController;

  late TextEditingController _descriptionController;
  late TextEditingController _photoUrlController;

  @override
  void initState() {
    super.initState();
    _makeController = TextEditingController();
    _modelController = TextEditingController();
    _colorController = TextEditingController();
    _yearController = TextEditingController();
    _mileageController = TextEditingController();

    _descriptionController = TextEditingController();
    _photoUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _yearController.dispose();
    _mileageController.dispose();

    _descriptionController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveCar() async {
    final url =
        Uri.parse('https://used-car-dealership-be.onrender.com/api/cars/');
    final Map<String, dynamic> requestBody = {
      "make": _makeController.text,
      "model": _modelController.text,
      "color": _colorController.text,
      "year": int.tryParse(_yearController.text) ?? 0,
      "mileage": int.tryParse(_mileageController.text) ?? 0,
      "description": _descriptionController.text,
      "photo_url": _photoUrlController.text
    };

    final response = await http.post(
      url,
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      showSuccessSnackbar(); // Handle snackbar and navigation in a separate function
    } else {
      showErrorSnackbar();
    }
  }

  void showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Car added successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Wait for 2 seconds (SnackBar duration), then navigate
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
          context, '/car_list_page'); // Redirect to car list page
    });
  }

  void showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to add car!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _mileageController,
                decoration: InputDecoration(labelText: 'Mileage'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _photoUrlController,
                decoration: InputDecoration(labelText: 'Photo URL'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCar,
                child: Text('Save Car'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
