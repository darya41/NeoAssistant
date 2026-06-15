import 'package:flutter/material.dart';

class DiaryEntry {
  final String text;
  final TimeOfDay time;
  final int examId;
  final DateTime dateTime;

  DiaryEntry({
    required this.text,
    required this.time,
    required this.examId,
    required this.dateTime,
  });
}