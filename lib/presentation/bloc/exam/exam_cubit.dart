import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards/config/app_config.dart';
import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/exam_data.dart';
import 'package:flashcards/domain/entities/exam_result.dart';
import 'package:flashcards/domain/entities/flash_card.dart';

part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {

  late List<Flashcard> flashcards;
  int currentFlashcardIndex = 0;
  ExamResult examResult = ExamResult();
  final LocalRepository localRepository;

  ExamCubit({required this.localRepository,required ExamData examData}) : super(examData.flashcards.isNotEmpty ? LoadingState() : ErrorState()){
    flashcards = examFlashcards(examData);
    emit(
      ShowCurrentFlashcardState(
        flashcard: flashcards.first,
        currentStep: 1,
        totalSteps: flashcards.length
      )
    );
  }

  List<Flashcard> examFlashcards(ExamData examData){
    //Random order
    examData.flashcards.shuffle();
    //If it is a quick exam, it will only use some cards
    if(examData.isQuickExam){
      return examData.flashcards.sublist(0,AppConfig.quickReviewQuestionNumber);
    }
    return examData.flashcards;
  }

  Flashcard _currentFlashcard() => flashcards[currentFlashcardIndex];

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
      emit(
        ShowCurrentFlashcardState(
          flashcard: flashcards[currentFlashcardIndex],
          currentStep: currentFlashcardIndex+1,
          totalSteps: flashcards.length
        )
      );
    } else {
      emit(FinishState(examResult));
    }
  }

  void finish(){
    emit(FinishState(examResult));
  }

}
