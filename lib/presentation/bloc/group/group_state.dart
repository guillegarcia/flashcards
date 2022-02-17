part of 'group_cubit.dart';

abstract class GroupState extends Equatable {
  const GroupState();
}

class LoadFlashcardsInProgressState extends GroupState {
  @override
  List<Object> get props => [];
}

class LoadFlashcardsSuccessState extends GroupState {
  LoadFlashcardsSuccessState(this.flashcards,this.reviewFlashcards);

  List<Flashcard> flashcards;
  List<Flashcard> reviewFlashcards;

  @override
  List<Object> get props => [flashcards,reviewFlashcards];
}

class LoadFlashcardsErrorState extends GroupState {
  @override
  List<Object> get props => [];
}
