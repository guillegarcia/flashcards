import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

          //Recuperar la información
          List<
              List<dynamic>> flashcardsImportedInfo = const CsvToListConverter()
              .convert(csvResponse);


          for (var flashcardImportedInfo in flashcardsImportedInfo) {
            String question = flashcardImportedInfo[0];
            String answer = flashcardImportedInfo[1];
            var newFlashcard = Flashcard(question: question, answer: answer);
            _localRepository.insertFlashcard(newFlashcard, groupId);
            importedFlashcards.add(newFlashcard);
          }

          groupBloc.loadFlashcards();

          //Contadores para mensaje de resultado:
          // Numero de elementos correctos
          // Numero de elementos cortados por superar tamaño
          // Numero de elementos sin columnas suficientes
          // Numero de elementos con columnas de mas
          // Si se ha sobrepasado el maximo de filas

          //Crear las tarjetas en el grupo
          // Contador de tarjetas que no se han creado porque la pregunta ya existía

          emit(ImportSuccessState(importedFlashcards: importedFlashcards));
        }
      } catch (e) {
        emit(ImportErrorState());
      }
    }
  }
}
