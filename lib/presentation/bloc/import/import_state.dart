part of 'import_cubit.dart';

abstract class ImportState extends Equatable {
  const ImportState();
}

class ImportInitial extends ImportState {
  @override
  List<Object> get props => [];
}

class ImportErrorState extends ImportState {
  @override
  List<Object> get props => [];
}

class ImportLoadingState extends ImportState {
  @override
  List<Object> get props => [];
}

class ImportSuccessState extends ImportState {
  final List<Flashcard> importedFlashcards;
  final int rowsExceedMaxLengthCounter;
  final int rowsWithLessThanTwoColumnsCounter;
  final bool maxFlashcardInGroupReached;

  const ImportSuccessState({
    required this.importedFlashcards,
    required this.rowsExceedMaxLengthCounter,
    required this.rowsWithLessThanTwoColumnsCounter,
    required this.maxFlashcardInGroupReached,
  });

  @override
  List<Object> get props => [importedFlashcards];
}