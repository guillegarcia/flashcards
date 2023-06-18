part of 'import_from_csv_cubit.dart';

@immutable
abstract class ImportFromCsvState {}

class ImportFromCsvInitialState extends ImportFromCsvState {}
class ImportFromCsvInProgressState extends ImportFromCsvState {}
class ImportFromCsvSuccessState extends ImportFromCsvState {
  final ImportFlashcardsFromCsvResult importResult;

  ImportFromCsvSuccessState({required this.importResult});
}
class ImportFromCsvErrorState extends ImportFromCsvState {}
