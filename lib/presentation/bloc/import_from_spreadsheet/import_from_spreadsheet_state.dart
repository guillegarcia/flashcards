part of 'import_from_spreadsheet_cubit.dart';

abstract class ImportFromSpreadsheetState extends Equatable {
  const ImportFromSpreadsheetState();
}

class ImportInitialState extends ImportFromSpreadsheetState {
  @override
  List<Object> get props => [];
}

class ImportErrorState extends ImportFromSpreadsheetState {
  @override
  List<Object> get props => [];
}

class ImportLoadingState extends ImportFromSpreadsheetState {
  @override
  List<Object> get props => [];
}

class ImportSuccessState extends ImportFromSpreadsheetState {
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