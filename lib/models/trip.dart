class Trip {
  final String title;
  final String description;
  final DateTime beginDate;
  final DateTime endDate;
  final List<String> participants;
  final Map<String, dynamic> beginPoint;
  final Map<String, dynamic> endPoint;
  final String imageUrl;

  Trip({
    required this.title,
    required this.description,
    required this.beginDate,
    required this.endDate,
    required this.participants,
    required this.beginPoint,
    required this.endPoint,
    this.imageUrl = '',
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      title: json['title'],
      description: json['description'] ?? '',
      beginDate: DateTime.parse(json['begin_date']),
      endDate: DateTime.parse(json['end_date']),
      participants: List<String>.from(json['participants']),
      beginPoint: json['begin_point'],
      endPoint: json['end_point'],
      imageUrl: json['image_url'] ?? '',
    );
  }
}
