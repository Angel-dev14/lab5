import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './formatter/date_time_formatter.dart';
import 'model/exam.dart';

class CreateExam extends StatefulWidget {
  final Function createCallback;

  CreateExam({required this.createCallback}) {}

  @override
  State<StatefulWidget> createState() => _CreateExamState();
}

class _CreateExamState extends State<CreateExam> {
  final _titleController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();

  DateTime? dateTime;

  void _create() {
    if (_titleController.text.isEmpty) {
      return;
    }
    if (dateTime == null) {
      return;
    }
    if (_latController.text.isEmpty) {
      return;
    }
    if (_longController.text.isEmpty) {
      return;
    }
    final String title = _titleController.text;
    final double lat = double.parse(_latController.text);
    final double long = double.parse(_longController.text);
    final location = GeoPoint(lat, long);
    Exam exam = Exam(title: title, dateTime: dateTime!, location: location);
    widget.createCallback(exam);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration:
                InputDecoration(labelText: "Title", icon: Icon(Icons.title)),
          ),
          DateTimeField(
            decoration: InputDecoration(
                labelText: "Date and Time", icon: Icon(Icons.date_range)),
            mode: DateTimeFieldPickerMode.dateAndTime,
            dateFormat: DateTimeFormatter.formatter,
            selectedDate: dateTime,
            onDateSelected: (DateTime value) {
              setState(() {
                dateTime = value;
              });
            },
          ),
          TextField(
            controller: _latController,
            decoration: InputDecoration(
                labelText: "Latitude", icon: Icon(Icons.location_city)),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _longController,
            decoration: InputDecoration(
                labelText: "Longitude", icon: Icon(Icons.location_city)),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(onPressed: _create, child: Text("Add"))
        ],
      ),
    );
  }
}
