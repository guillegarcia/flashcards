import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flashcards/domain/use_cases/import_flashcards_from_csv.dart';
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
          String csvString = await File(file.path!).readAsString();

          int groupId = (groupBloc.group.id!);

          ImportFlashcardsFromCsv importFlashcards = ImportFlashcardsFromCsv(csvString: csvString, groupId: groupId, localRepository: localRepository);
          ImportFlashcardsFromCsvResult importResult = importFlashcards.execute();

          groupBloc.loadFlashcards();

          emit(ImportFromCsvSuccessState(importResult: importResult));
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

}