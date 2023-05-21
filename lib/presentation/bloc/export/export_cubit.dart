import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../domain/entities/flash_card.dart';

part 'export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  final List<Flashcard> flashcards;

  ExportCubit({required this.flashcards}) : super(ExportInitialState());

  void exportFlashcards() async{
    try {
      print('exporting!');
      String csvPath = await _flashcardsListToCSV(flashcards);
      emit(ExportSuccessState(csvPath:csvPath));
      shareCsv(csvPath);
    } catch (e) {
      emit(ExportErrorState());
    }
  }

  Future<String> _flashcardsListToCSV(List<Flashcard> flashcards) async {
    String csvData = const ListToCsvConverter().convert(_listOfFlashCardsToListForCsv(flashcards));
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/flashcards-${DateTime.now()}.csv";
    print(path);
    final File file = File(path);
    await file.writeAsString(csvData);
    return path;
  }

  List<List<String>> _listOfFlashCardsToListForCsv(List<Flashcard> flashcards)  {
    List<List<String>> listForCsv = [];

    for (var flashcard in flashcards) {
      listForCsv.add([flashcard.question,flashcard.answer]);
    }

    return listForCsv;
  }

  void shareCsv(csvPath) {
    Share.shareXFiles([XFile(csvPath)]);
  }
}
