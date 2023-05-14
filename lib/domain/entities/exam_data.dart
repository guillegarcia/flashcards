import 'flash_card.dart';

class ExamData {
  final List<Flashcard> flashcards;
  final bool isQuickExam;

  ExamData({required this.flashcards, this.isQuickExam = false});
}