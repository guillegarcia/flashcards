import 'package:csv/csv.dart';
import 'package:flashcards/domain/entities/flash_card.dart';

class CsvToFlashcards {
  final String csvString;

  CsvToFlashcards({required this.csvString});

  CsvToFlashcardsResult execute() {

    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);
    List<Flashcard> flashcards = _csvListToListOfFlashcards(rowsAsListOfValues);

    CsvToFlashcardsResult result = CsvToFlashcardsResult(
      importedFlashcards: flashcards
    );

    return result;
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
}

class CsvToFlashcardsResult {
  List<Flashcard> importedFlashcards;
  CsvToFlashcardsResult({required this.importedFlashcards});
  //FlashCards que sobrepasan el límite de tamaño en preguntas o respuestas
  //Columnas ignoradas de más
  //Filas con columnas de menos
  //Filas ignoradas por sobrepasar el límite de pregutnas
}

//TODO: Fuera de la responsabilida de esta clase al insertarlas en un grupo:
//Preguntas repetidas que ya exiten => no se importan
//Sobreparaso el límite de preguntas contando las que ya tiene el grupo