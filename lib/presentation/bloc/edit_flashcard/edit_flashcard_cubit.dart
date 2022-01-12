import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';

part 'edit_flashcard_state.dart';

class EditFlashcardCubit extends Cubit<EditFlashcardState> {
  EditFlashcardCubit(this._localRepository,{required GroupCubit this.groupBloc}) : super(EditFlashcardInitial());

  final GroupCubit groupBloc;
  final LocalRepository _localRepository;

  void editFlashcard(Flashcard flashcard) async{
    try{
      if(groupBloc.state is LoadFlashcardsSuccessState){
        emit(EditFlashcardInProgressState());
        int groupId = (groupBloc.group.id!);
        await _localRepository.updateFlashcard(flashcard);
        groupBloc.loadFlashcards();//.addCreatedGroup(group);
        emit(EditFlashcardSuccessState());
      }
    } catch (e) {
      emit(EditFlashcardErrorState());
    }
  }
}
