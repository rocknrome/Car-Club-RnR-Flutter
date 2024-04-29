import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarEditPage extends StatefulWidget {
  final int carId;

  const CarEditPage({Key? key, required this.carId}) : super(key: key);

  @override
  _CarEditPageState createState() => _CarEditPageState();
}

class _CarEditPageState extends State<CarEditPage> {
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _colorController;
  late TextEditingController _yearController;
  late TextEditingController _mileageController;
  late TextEditingController _priceController;
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
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    _photoUrlController = TextEditingController();

    // Fetch car details and set initial values in form fields
    fetchCarDetails(widget.carId);
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> fetchCarDetails(int carId) async {
    final url = Uri.parse(
        'https://used-car-dealership-be.onrender.com/api/cars/$carId/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> carData = jsonDecode(response.body);
      setState(() {
        _makeController.text = carData['make'];
        _modelController.text = carData['model'];
        _colorController.text = carData['color'];
        _yearController.text = carData['year'].toString();
        _mileageController.text = carData['mileage'].toString();
        _priceController.text = carData['price'];
        _descriptionController.text = carData['description'];
        _photoUrlController.text = carData['photo_url'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch car details!'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> _saveChanges(int carId) async {
    final url = Uri.parse(
        'https://used-car-dealership-be.onrender.com/api/cars/$carId/');
    final Map<String, dynamic> requestBody = {
      "id": carId,
      "make": _makeController.text,
      "model": _modelController.text,
      "color": _colorController.text,
      "year": int.tryParse(_yearController.text) ?? 0,
      "mileage": int.tryParse(_mileageController.text) ?? 0,
      "price": _priceController.text,
      "description": _descriptionController.text,
      "photo_url": _photoUrlController.text
    };

    final response = await http.put(
      url,
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
            content: Text('Car details updated successfully!'),
            duration: Duration(seconds: 2),
          ))
          .closed
          .then((_) {
        Navigator.of(context).pop();
      });
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Edit Car'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Car ID: ${widget.carId}',
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              TextFormField(
                  controller: _makeController,
                  decoration: InputDecoration(labelText: 'Make')),
              TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(labelText: 'Model')),
              TextFormField(
                  controller: _colorController,
                  decoration: InputDecoration(labelText: 'Color')),
              TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(labelText: 'Year'),
                  keyboardType: TextInputType.number),
              TextFormField(
                  controller: _mileageController,
                  decoration: InputDecoration(labelText: 'Mileage'),
                  keyboardType: TextInputType.number),
              TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price')),
              TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description')),
              TextFormField(
                  controller: _photoUrlController,
                  decoration: InputDecoration(labelText: 'Photo URL')),
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
      ),
    );
  }
}
