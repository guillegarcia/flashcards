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
  final ImportFlashcardsFromCsvResult importResult;

  const ImportSuccessState({
    required this.importResult
  });

  @override
  List<Object> get props => [importResult];
}