import 'package:csv/csv.dart';
import 'package:flashcards/config/app_config.dart';
import 'package:flashcards/domain/entities/flash_card.dart';

import '../../data/repositories/local_repository.dart';

class ImportFlashcardsFromCsv {
  final LocalRepository localRepository;
  final String csvString;
  final int groupId;
  //Strings que superan el tamaño máximo de texto permitido
  List<String> maxLengthErrorValues = [];

  ImportFlashcardsFromCsv({required this.csvString, required this.groupId, required this.localRepository});

  ImportFlashcardsFromCsvResult execute() {

    //String de CSV a lista de listas dinámicas
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

    //Pasar a lista de objetos flashcards
    List<Flashcard> flashcards = _csvListToListOfFlashcards(rowsAsListOfValues);

    //TODO: Consultar primero en bbdd el número de preguntas actual para ver cuantas podemos añadir de las importadas sin sobrepasar el máximo
    //AppConfig.maxFlashcardInGroup

    //Guardamos en base de datos
    for(Flashcard flashcard in flashcards){
      //insertar en base de datos
      print('Guardando ${flashcard.question} en bbdd');
      localRepository.insertFlashcard(flashcard, groupId);
    }

    ImportFlashcardsFromCsvResult result = ImportFlashcardsFromCsvResult(
      flashcards: flashcards,
      maxLengthErrorValues: maxLengthErrorValues
    );

    return result;
  }

  List<Flashcard> _csvListToListOfFlashcards(List<List<dynamic>> csvColumnsList)  {
    print('_csvListToListOfFlashcards ${csvColumnsList.length}');
    List<Flashcard> flashcards = [];

    for (List<dynamic> csvRowList in csvColumnsList) {
      //El tamaño tiene que ser al menos dos, una columna para las preguntas y otra para las respuestas (el resto se ignorarán)
      if(csvRowList.length >= 2){
        String question = csvRowList[0];
        String answer = csvRowList[1];
        //Si alguno de los valores es vacío se ignoran
        if(question.isNotEmpty && answer.isNotEmpty) {
          //Si alguno de los valroes sobrepara el límite de tamaño se ignoran y se informa al usuario
          if(question.length>AppConfig.flashcardTextMaxLength || answer.length>AppConfig.flashcardTextMaxLength) {
            print('pregunta supera el limite');
            if(question.length > AppConfig.flashcardTextMaxLength) maxLengthErrorValues.add(question);
            if(answer.length > AppConfig.flashcardTextMaxLength) maxLengthErrorValues.add(answer);
          } else {
            print('Leido flashcard $question');
            Flashcard flashcard = Flashcard(question: question, answer: answer);
            flashcards.add(flashcard);
          }
        }
      }
    }

    return flashcards;
  }
}

class ImportFlashcardsFromCsvResult {
  List<Flashcard> flashcards;
  List<String> maxLengthErrorValues;
  ImportFlashcardsFromCsvResult({required this.flashcards, required this.maxLengthErrorValues});
  //FlashCards que sobrepasan el límite de tamaño en preguntas o respuestas
  //Columnas ignoradas de más
  //Filas con columnas de menos
  //Filas ignoradas por sobrepasar el límite de pregutnas
}

//TODO: Fuera de la responsabilida de esta clase al insertarlas en un grupo:
//Preguntas repetidas que ya exiten => no se importan
//Sobreparaso el límite de preguntas contando las que ya tiene el grupo