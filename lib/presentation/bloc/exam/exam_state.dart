part of 'exam_cubit.dart';

abstract class ExamState extends Equatable {
  const ExamState();
}

class LoadingState extends ExamState {

  @override
  List<Object> get props => [];
}

class ShowCurrentFlashcardState extends ExamState {
  final Flashcard flashcard;
  final int currentStep;
  final int totalSteps;

  const ShowCurrentFlashcardState({
    required this.flashcard,
    required this.currentStep,
    required this.totalSteps
  });

  @override
  List<Object> get props => [currentStep];
}
/*
class FlashcardQuestionState extends ExamState {

  FlashcardQuestionState(this.flashcard);

  Flashcard flashcard;

  @override
  List<Object> get props => [flashcard];
}

class FlashcardAnswerState extends ExamState {

  FlashcardAnswerState(this.flashcard);

  Flashcard flashcard;

  @override
  List<Object> get props => [flashcard];
}
*/
class FinishState extends ExamState {

  FinishState(this.examResult);

  ExamResult examResult;

  @override
  List<Object> get props => [];
}

class ErrorState extends ExamState {
  @override
  List<Object> get props => [];
}
