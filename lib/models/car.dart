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
      make: json['make'] ?? 'N/A',
      model: json['model'] ?? 'N/A',
      color: json['color'] ?? 'N/A',
      year: json['year'] ?? 0,
      mileage: json['mileage'] ?? 0,
      price: double.parse(json['price'].toString() ?? '0'),
      description: json['description'] ?? 'No description available',
      photoUrl: json['photo_url'] ?? 'https://example.com/default-image.jpg',
    );
  }
}
