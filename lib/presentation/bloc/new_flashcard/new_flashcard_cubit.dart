import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';

part 'new_flashcard_state.dart';

class NewFlashcardCubit extends Cubit<NewFlashcardState> {
  NewFlashcardCubit(this._localRepository,{required GroupCubit this.groupBloc}) : super(NewFlashcardInitial());

  final GroupCubit groupBloc;
  final LocalRepository _localRepository;

  void createFlashcard(Flashcard flashcard) async{
    try{
      if(groupBloc.state is LoadFlashcardsSuccessState){
        emit(CreateFlashcardInProgressState());
        int groupId = (groupBloc.group.id!);
        flashcard.id = await _localRepository.insertFlashcard(flashcard,groupId);
        groupBloc.loadFlashcards();//.addCreatedGroup(group);
        emit(CreateFlashcardSuccessState());
      }
    } catch (e) {
      emit(CreateFlashcardErrorState());
    }
  }
}
