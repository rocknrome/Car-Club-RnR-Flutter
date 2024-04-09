import 'package:flutter/material.dart';

class CarEditPage extends StatelessWidget {
  final int carId;

  const CarEditPage({Key? key, required this.carId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Car'),
      ),
      body: Center(
        child: Text('Edit Car ID: $carId'),
      ),
    );
  }
}
