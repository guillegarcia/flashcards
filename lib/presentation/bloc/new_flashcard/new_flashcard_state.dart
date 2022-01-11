part of 'new_flashcard_cubit.dart';

abstract class NewFlashcardState extends Equatable {
  const NewFlashcardState();
}

class NewFlashcardInitial extends NewFlashcardState {
  @override
  List<Object> get props => [];
}

class CreateFlashcardInProgressState extends NewFlashcardState {
  @override
  List<Object> get props => [];
}

class CreateFlashcardSuccessState extends NewFlashcardState {
  @override
  List<Object> get props => [];
}

class CreateFlashcardErrorState extends NewFlashcardState {
  @override
  List<Object> get props => [];
}
