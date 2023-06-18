import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards/config/app_config.dart';
import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/domain/use_cases/import_flashcards_from_csv.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

part 'import_from_spreadsheet_state.dart';

class ImportFromSpreadsheetCubit extends Cubit<ImportFromSpreadsheetState> {
  ImportFromSpreadsheetCubit(this._localRepository,{required this.groupBloc}) : super(ImportInitialState());

  final GroupCubit groupBloc;
  final LocalRepository _localRepository;

  void importFromSpreadsheet(String spreadsheetUrl) async {
    if(groupBloc.state is LoadFlashcardsSuccessState) {
      emit(ImportLoadingState());
      int groupId = (groupBloc.group.id!);

      List<Flashcard> importedFlashcards = [];
      try {
        //Obtener datos como CSV
        var url = Uri.parse(spreadsheetUrl);

        // Await the http get response, then decode the json-formatted response.
        var response = await http.get(url);
        if (response.statusCode == 200) {
          String csvResponse = utf8.decode(response.bodyBytes);
          print('csvResponse spreadsheet: $csvResponse');

          int rowsExceedMaxLengthCounter = 0;
          int rowsWithLessThanTwoColumnsCounter = 0;
          bool maxFlashcardInGroupReached = false;

          ImportFlashcardsFromCsv csvToFlashcards = ImportFlashcardsFromCsv(csvString: csvResponse,groupId: groupId,localRepository: _localRepository);
          ImportFlashcardsFromCsvResult importResult = csvToFlashcards.execute();

          groupBloc.loadFlashcards();

          emit(ImportSuccessState(
            importResult: importResult
          ));
        } else {
          print("Error al recuperar por URL");
          emit(ImportErrorState());
        }
      } catch (e) {
        print("Error al importar de google: ${e.toString()}");
        emit(ImportErrorState());
      }
    }
  }
}
