import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards/config/app_config.dart';
import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

part 'import_state.dart';

class ImportCubit extends Cubit<ImportState> {
  ImportCubit(this._localRepository,{required GroupCubit this.groupBloc}) : super(ImportInitial());

  final GroupCubit groupBloc;
  final LocalRepository _localRepository;

  void importFromSpreadsheet(String spreadsheetUrl) async {
    if(groupBloc.state is LoadFlashcardsSuccessState) {
      emit(ImportLoadingState());
      int groupId = (groupBloc.group.id!);

      List<Flashcard> importedFlashcards = [];
      try {
        //Buscar el spreadsheet

        //Existe?

        //Obtener datos como CSV
        var url = Uri.parse(spreadsheetUrl);

        // Await the http get response, then decode the json-formatted response.
        var response = await http.get(url);
        if (response.statusCode == 200) {
          String csvResponse = response.body;
          print('csvResponse: $csvResponse');

          int rowsExceedMaxLengthCounter = 0;
          int rowsWithLessThanTwoColumnsCounter = 0;
          bool maxFlashcardInGroupReached = false;

          //Recuperar la información
          List<
              List<dynamic>> flashcardsImportedInfo = const CsvToListConverter()
              .convert(csvResponse);

          int rowCounter = 0;
          for (var flashcardImportedInfo in flashcardsImportedInfo) {
            rowCounter++;
            if(flashcardImportedInfo != null && flashcardsImportedInfo.length>=2) {
              String question = flashcardImportedInfo[0];
              String answer = flashcardImportedInfo[1];

              if (question.length <= AppConfig.flashcardTextMaxLength &&
                  question.length <= AppConfig.flashcardTextMaxLength) {
                var newFlashcard = Flashcard(
                    question: question, answer: answer);
                _localRepository.insertFlashcard(newFlashcard, groupId);
                importedFlashcards.add(newFlashcard);
              } else {
                rowsExceedMaxLengthCounter++;
              }
            } else {
              rowsWithLessThanTwoColumnsCounter++;
            }
            if(rowCounter>= AppConfig.maxFlashcardInGroup){
              maxFlashcardInGroupReached = true;
              break;
            }
          }

          groupBloc.loadFlashcards();

          // TODO: Contador de tarjetas que no se han creado porque la pregunta ya existía

          emit(ImportSuccessState(
            importedFlashcards: importedFlashcards,
            rowsExceedMaxLengthCounter: rowsExceedMaxLengthCounter,
            rowsWithLessThanTwoColumnsCounter: rowsWithLessThanTwoColumnsCounter,
            maxFlashcardInGroupReached: maxFlashcardInGroupReached,
          ));
        }
      } catch (e) {
        emit(ImportErrorState());
      }
    }
  }
}
