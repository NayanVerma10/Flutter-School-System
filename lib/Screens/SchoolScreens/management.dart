import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Schools/widgets/view_event.dart';
import 'package:Schools/models/event.dart';
import 'package:firebase_helpers/firebase_helpers.dart';

class Management extends StatefulWidget {
  final String schoolCode;

  Management(this.schoolCode);
  @override
  _ManagementState createState() => _ManagementState(schoolCode);
}

class _ManagementState extends State<Management> {
  _ManagementState(String schoolCode);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
