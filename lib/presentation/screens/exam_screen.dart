import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/presentation/bloc/exam/exam_cubit.dart';
import 'package:flashcards/presentation/screens/groups_screen.dart';
import 'package:flashcards/presentation/screens/result_screen.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../domain/entities/exam_data.dart';

class ExamScreen extends StatefulWidget {
  final ExamData examData;

  const ExamScreen({required this.examData,Key? key}) : super(key: key);

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {

  bool _showButtons = false;
  bool _visibleFlashCard = true;
  FlipCardController _flashcardController = FlipCardController();

  final ButtonStyle resultButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 48,vertical: 24)
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExamCubit(
        examData: widget.examData,
        localRepository: context.read<SQLiteLocalDatasource>()
      ),
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            actions: [
              BlocBuilder<ExamCubit, ExamState>(
                builder: (context, state) {
                  return TextButton(
                    onPressed: (){
                      context.read<ExamCubit>().finish();
                    },
                    child: Text(AppLocalizations.of(context)!.finish.toUpperCase(),
                      style: const TextStyle(color: Colors.black),
                    )
                  );
                },
              )
            ],
          ),
          body: Container(
            child: BlocConsumer<ExamCubit, ExamState>(
              builder: (context, state) {
                return _buildExamPageContent(context, state);
              },
              listener: (context, state) {
                print('listener $state');
                if(state is ShowCurrentFlashcardState){
                  setState(() {
                    _showButtons = false;
                    _flashcardController.toggleCardWithoutAnimation();
                    //_flashcardController.skew(1,curve: Curves.easeIn,duration: const Duration(milliseconds: 1));
                    _visibleFlashCard = true;
                  });
                }
                if(state is FinishState){
                  Navigator.pushNamedAndRemoveUntil(context, ResultScreen.routeName,ModalRoute.withName(GroupsScreen.routeName), arguments: state.examResult);
                }
              },
            ),
          ),
      ),
    );
  }

  _buildExamPageContent(BuildContext context, ExamState state) {
    if(state is LoadingState) {
      print('LoadingState');
      return const Center(
          child: CircularProgressIndicator()
      );
    } else if(state is ShowCurrentFlashcardState) {
      print('build new ShowCurrentFlashcardState');

      return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StepProgressIndicator(
                  totalSteps: state.totalSteps,
                  currentStep: state.currentStep,
                  selectedColor: state.flashcard.color!,
                  unselectedColor: Colors.grey,
                ),
              ),
            ),
            Center(
              child: AnimatedOpacity(
                opacity: _visibleFlashCard ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: FlashCardWidget(
                  flashcard: state.flashcard,
                  controller: _flashcardController,
                  onAnswerShown: (onAnswerSide){
                    setState(() {
                      _showButtons = onAnswerSide;
                    });
                  }
                )
              ),
              //)
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _showButtons ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: resultButtonStyle,
                        onPressed: () async {
                          setState(() {
                            _visibleFlashCard = false;
                          });
                          await Future.delayed(const Duration(milliseconds: 200));
                          context.read<ExamCubit>().saveCurrentCardFailed();
                        }, child: const Icon(Icons.close,color: Colors.redAccent,)),
                    ElevatedButton(
                        style: resultButtonStyle,
                        onPressed: () async {
                          setState(() {
                            _visibleFlashCard = false;
                          });
                          await Future.delayed(const Duration(milliseconds: 200));
                          context.read<ExamCubit>().saveCurrentCardSuccess();
                        }, child: const Icon(Icons.check,color: Colors.green,)),
                  ],
                ),
              ) : const SizedBox.shrink(),
            )
          ]
      );
    } else {
      //TODO: ERROR
      return Container();
    }
  }
}

class FlashCardPageWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;

  const FlashCardPageWidget(this.text,{this.color,this.textColor,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(child: Text(text,style: TextStyle(color:textColor ?? Colors.black,fontSize: 20))),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              0, // Move to right 10  horizontally
              0.0, // Move to bottom 10 Vertically
            ),
          )
        ]
      ),
      height: 500,
      width: 300,

    );
  }
}

class FlashCardWidget extends StatelessWidget {

  final Flashcard flashcard;
  final BoolCallback? onAnswerShown;
  final FlipCardController controller;
  const FlashCardWidget({required this.flashcard, required this.controller, this.onAnswerShown, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: FlashCardPageWidget(
        flashcard.question, color: flashcard.color, textColor: Colors.white,),
      back: FlashCardPageWidget(flashcard.answer, color: Colors.white),
      onFlipDone: onAnswerShown,
      controller: controller,
    );
  }
}
