import 'flash_card.dart';

class ExamData {
  final List<Flashcard> flashcards;
  final ExamType type;

  ExamData({required this.flashcards, this.type = ExamType.general});

  get isQuickExam => type == ExamType.quick;
}

enum ExamType {general,quick,onlyOneCard}