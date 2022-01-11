part of 'group_cubit.dart';

abstract class GroupState extends Equatable {
  const GroupState();
}

class LoadFlashcardsInProgressState extends GroupState {
  @override
  List<Object> get props => [];
}

class LoadFlashcardsSuccessState extends GroupState {
  LoadFlashcardsSuccessState(this.flashcards);

  List<Flashcard> flashcards;

  @override
  List<Object> get props => [flashcards];
}

class LoadFlashcardsErrorState extends GroupState {
  @override
  List<Object> get props => [];
}
