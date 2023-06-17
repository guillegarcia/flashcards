import 'flash_card.dart';
import 'package:flutter/material.dart';

class ExamResult {
  Color color = Colors.green;
  int rightCounter = 0;
  List<Flashcard> failedFlashcard = [];
}