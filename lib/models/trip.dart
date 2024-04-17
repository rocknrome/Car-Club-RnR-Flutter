import 'dart:convert';

class Trip {
  final String id;
  final String title;
  final String description;
  final DateTime beginDate;
  final DateTime endDate;
  final List<String> participants;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Trip({
    required this.id,
    required this.title,
    required this.description,
    required this.beginDate,
    required this.endDate,
    required this.participants,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      beginDate: DateTime.parse(json['begin_date']),
      endDate: DateTime.parse(json['end_date']),
      participants: List<String>.from(json['participants']),
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'begin_date': beginDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'participants': participants,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
