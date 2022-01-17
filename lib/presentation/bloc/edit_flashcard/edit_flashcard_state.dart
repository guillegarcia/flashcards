part of 'edit_flashcard_cubit.dart';

abstract class EditFlashcardState extends Equatable {
  const EditFlashcardState();
}

class EditFlashcardInitial extends EditFlashcardState {
  @override
  List<Object> get props => [];
}

class EditFlashcardInProgressState extends EditFlashcardState {
  @override
  List<Object> get props => [];
}

class EditFlashcardSuccessState extends EditFlashcardState {
  @override
  List<Object> get props => [];
}

class EditFlashcardErrorState extends EditFlashcardState {
  @override
  List<Object> get props => [];
}

class DeleteFlashcardInProgressState extends EditFlashcardState {
  @override
  List<Object> get props => [];
}

class DeleteFlashcardSuccessState extends EditFlashcardState {
  @override
  List<Object> get props => [];
}

class DeleteFlashcardErrorState extends EditFlashcardState {
  @override
  List<Object> get props => [];
}