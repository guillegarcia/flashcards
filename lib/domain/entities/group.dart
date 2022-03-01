import 'dart:ui';
import 'flash_card.dart';

class Group {
  int? id;
  String name;
  Color color;
  String? description;

  List<Flashcard>? cards;

  Group({this.id, required this.color ,required this.name, this.description, this.cards});
}