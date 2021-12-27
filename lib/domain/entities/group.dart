import 'flash_card.dart';

class Group {
  String? id;
  String name;
  String? description;

  List<FlashCard>? cards;

  Group({this.id, required this.name, this.description, this.cards});
}