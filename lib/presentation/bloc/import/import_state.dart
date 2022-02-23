part of 'import_cubit.dart';

abstract class ImportState extends Equatable {
  const ImportState();
}

class ImportInitial extends ImportState {
  @override
  List<Object> get props => [];
}

class ImportErrorState extends ImportState {
  @override
  List<Object> get props => [];
}

class ImportLoadingState extends ImportState {
  @override
  List<Object> get props => [];
}

class ImportSuccessState extends ImportState {
  List<Flashcard> importedFlashcards;
  // Numero de elementos correctos
  // Numero de elementos cortados por superar tamaño
  // Numero de elementos sin columnas suficientes
  // Numero de elementos con columnas de mas
  // Si se ha sobrepasado el maximo de filas

  ImportSuccessState({required this.importedFlashcards});

  @override
  List<Object> get props => [importedFlashcards];
}