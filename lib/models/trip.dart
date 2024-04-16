class Trip {
  final int? id;
  final String title;
  final String description;
  final DateTime beginDate;
  final DateTime endDate;
  final List<String> participants;
  final Map<String, dynamic>? beginPoint;
  final Map<String, dynamic>? endPoint;
  final String imageUrl;

  Trip({
    this.id,
    required this.title,
    required this.description,
    required this.beginDate,
    required this.endDate,
    required this.participants,
    this.beginPoint,
    this.endPoint,
    this.imageUrl = '',
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      beginDate: DateTime.parse(json['begin_date']),
      endDate: DateTime.parse(json['end_date']),
      participants: List<String>.from(json['participants']),
      beginPoint: json['begin_point'] != null
          ? Map<String, dynamic>.from(json['begin_point'])
          : null,
      endPoint: json['end_point'] != null
          ? Map<String, dynamic>.from(json['end_point'])
          : null,
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'begin_date': beginDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'participants': participants,
      'begin_point': beginPoint,
      'end_point': endPoint,
      'image_url': imageUrl,
    };
  }
}
