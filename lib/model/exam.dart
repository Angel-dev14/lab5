import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:nanoid/nanoid.dart';

class Exam {
  String id;
  String title;
  DateTime dateTime;
  GeoPoint location;

  Exam({this.id = '', required this.title, required this.dateTime, required this.location}) {
    if (id.isEmpty) {
      id = nanoid(6);
    }
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'dateTime': dateTime, 'location': location};

  static Exam fromJson(Map<String, dynamic> json) => Exam(
      id: json['id'],
      title: json['title'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(
          (json['dateTime'] as Timestamp).millisecondsSinceEpoch),
      location: json['location'],
  );
}
