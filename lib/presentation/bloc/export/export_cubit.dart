import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/flash_card.dart';

part 'export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  final List<Flashcard> flashcards;

  ExportCubit({required this.flashcards}) : super(ExportInProgressState()){
    exportFlashcards();
  }

  void exportFlashcards() async{
    try {
      print('exporting!');
      emit(ExportSuccessState());
    } catch (e) {
      emit(ExportErrorState());
    }
  }
}
