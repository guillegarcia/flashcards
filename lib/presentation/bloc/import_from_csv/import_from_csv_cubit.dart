import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

import '../../../data/repositories/local_repository.dart';
import '../../../domain/entities/flash_card.dart';
import '../group/group_cubit.dart';

part 'import_from_csv_state.dart';

class ImportFromCsvCubit extends Cubit<ImportFromCsvState> {

  final GroupCubit groupBloc;
  final LocalRepository localRepository;

  ImportFromCsvCubit({required this.localRepository,required this.groupBloc}) : super(ImportFromCsvInitialState());

  void import() async{
    print('import!');
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.path != null) {
          List<Flashcard> flashcards = await _getFlashcardsFromCSV(file.path!);
          //Save in database
          print('save in database');
          int groupId = (groupBloc.group.id!);
          await _insertFlashcardsInLocalStorage(flashcards, groupId);
          //Load group with new flashcards
          print('reloadgroup');
          groupBloc.loadFlashcards();

          emit(ImportFromCsvSuccessState(flashcards: flashcards));
        } else {
          print('file.path es null');
          emit(ImportFromCsvErrorState());
        }
      } else {
        print('No encontrado el fichero');
        emit(ImportFromCsvErrorState());
      }
      //shareCsv(csvPath);
    } catch (e) {
      print('catch ${e.toString()}');
      emit(ImportFromCsvErrorState());
    }
  }

  Future<List<Flashcard>> _getFlashcardsFromCSV(String filePath) async {
    String csvString = await File(filePath).readAsString();
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);
    List<Flashcard> flashcards = _csvListToListOfFlashcards(rowsAsListOfValues);
    //TODO: Tener en cuenta máximo de tamaño en preguntas
    //TODO: Tener en cuenta máximo de tamaño en respuestas
    //TODO: Tener en cuenta máximo de tarjetas por grupo -> también a la hora de añadirlas con las que ya existen si es el caso
    //TODO: Excepción concreta para caso en el que el CSV no tenga formato correcto (dos columnas)

    return flashcards;
  }

  List<Flashcard> _csvListToListOfFlashcards(List<List<dynamic>> csvColumnsList)  {
    List<Flashcard> flashcards = [];

    for (List<dynamic> csvRowList in csvColumnsList) {
      //El tamaño tiene que ser dos porque tiene qe haber una pregunta y una respuesta
      if(csvRowList.length == 2){
        String question = csvRowList[0];
        String answer = csvRowList[1];
        if(question.isNotEmpty && answer.isNotEmpty) {
          Flashcard flashcard = Flashcard(question: question, answer: answer);
          flashcards.add(flashcard);
        }
      }
    }

    return flashcards;
  }

  _insertFlashcardsInLocalStorage(List<Flashcard> flashcards, int groupId) {
    for(Flashcard flashcard in flashcards){
      localRepository.insertFlashcard(flashcard, groupId);
    }
  }
}