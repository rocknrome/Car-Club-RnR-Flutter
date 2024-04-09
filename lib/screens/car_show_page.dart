import 'package:flutter/material.dart';

class CarShowPage extends StatelessWidget {
  final int carId;

  const CarShowPage({Key? key, required this.carId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
      ),
      body: Center(
        child: Text('Car ID: $carId'),
      ),
    );
  }
}
