part of 'import_from_csv_cubit.dart';

@immutable
abstract class ImportFromCsvState {}

enum ImportFromCsvError {unknown,wrongFileExtension}

class ImportFromCsvInitialState extends ImportFromCsvState {}
class ImportFromCsvInProgressState extends ImportFromCsvState {}
class ImportFromCsvSuccessState extends ImportFromCsvState {
  final ImportFlashcardsFromCsvResult importResult;

  ImportFromCsvSuccessState({required this.importResult});
}
class ImportFromCsvErrorState extends ImportFromCsvState {
  final ImportFromCsvError error;

  ImportFromCsvErrorState({ this.error=ImportFromCsvError.unknown});
}
