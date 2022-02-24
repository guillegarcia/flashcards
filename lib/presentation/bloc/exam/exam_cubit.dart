import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/exam_result.dart';
import 'package:flashcards/domain/entities/flash_card.dart';

part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {

  final List<Flashcard> flashcards;
  int currentFlashcardIndex = 0;
  ExamResult examResult = ExamResult();
  final LocalRepository localRepository;

  ExamCubit({required this.localRepository,required this.flashcards}) : super(flashcards.isNotEmpty ? LoadingState() : ErrorState()){
    print('Constructor');
    //Random order
    flashcards.shuffle();
    emit(ShowCurrentFlashcardState(flashcards.first,1));
  }

  Flashcard _currentFlashcard() => flashcards[currentFlashcardIndex];

  /*void updateGroup(Group group) async{
    try{
      print('updateGroup cubit ${group.name}');
      emit(UpdateInProgressState());
      await _localRepository.updateGroup(group);
      if(groupsBloc.state is LoadSuccessState){
        groupsBloc.loadGroups();//.addCreatedGroup(group);
      }
      emit(UpdateSuccessState());
    } catch (e) {
      emit(UpdateErrorState());
    }
  }*/

  /*void showCurrentCardAnswer(){
    emit(FlashcardAnswerState(flashcards[currentFlashcardIndex]));
  }

  void showCurrentCardQuestion(){
    emit(FlashcardQuestionState(flashcards[currentFlashcardIndex]));
  }*/

  void saveCurrentCardSuccess(){
    localRepository.removeFromReview(_currentFlashcard().id!);
    examResult.rightCounter++;
    _showNextCard();
  }

  void saveCurrentCardFailed(){
    Flashcard currentFlashcard = _currentFlashcard();
    localRepository.markForReview(currentFlashcard.id!);
    examResult.failedFlashcard.add(currentFlashcard);
    _showNextCard();
  }

  void _showNextCard() {
    if(currentFlashcardIndex<flashcards.length-1) {
      currentFlashcardIndex++;
      emit(ShowCurrentFlashcardState(flashcards[currentFlashcardIndex],currentFlashcardIndex+1));
    } else {
      emit(FinishState(examResult));
    }
  }

  void finish(){
    emit(FinishState(examResult));
  }

}
