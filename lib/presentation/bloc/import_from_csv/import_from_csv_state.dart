part of 'import_from_csv_cubit.dart';

@immutable
abstract class ImportFromCsvState {}

class ImportFromCsvInitialState extends ImportFromCsvState {}
class ImportFromCsvInProgressState extends ImportFromCsvState {}
class ImportFromCsvSuccessState extends ImportFromCsvState {
  final List<Flashcard> flashcards;

  ImportFromCsvSuccessState({required this.flashcards});
}
class ImportFromCsvErrorState extends ImportFromCsvState {}
