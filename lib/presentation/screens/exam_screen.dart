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

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);

  static const routeName = '/exam_screen';

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {

  bool _showButtons = false;
  bool _visibleFlashCard = true;
  FlipCardController _flashcardController = FlipCardController();

  @override
  Widget build(BuildContext context) {
    List<Flashcard> flashcards = ModalRoute
        .of(context)!
        .settings
        .arguments as List<Flashcard>;

    return BlocProvider(
      create: (context) => ExamCubit(
        flashcards: flashcards,
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
                      style: TextStyle(color: Colors.grey),
                    )
                  );
                },
              )
            ],
          ),
          body: Container(
            child: BlocConsumer<ExamCubit, ExamState>(
              builder: (context, state) {
                if(state is ShowCurrentFlashcardState) {
                  return Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StepProgressIndicator(
                              totalSteps: flashcards.length,
                              currentStep: state.currentStep,
                              selectedColor: Theme.of(context).colorScheme.primary,
                              unselectedColor: Colors.grey,
                            ),
                          ),
                        ),
                        Center(child: AnimatedOpacity(
                          opacity: _visibleFlashCard ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: FlashCardWidget(
                              flashcard:state.flashcard,
                              controller: _flashcardController,
                              onAnswerShown: (onAnswerSide){
                                setState(() {
                                  _showButtons = onAnswerSide;
                                });
                              }
                            ),
                        )
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: _showButtons ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _visibleFlashCard = false;
                                      });
                                      await Future.delayed(const Duration(milliseconds: 200));
                                      //_flashcardController.toggleCard();
                                      context.read<ExamCubit>().saveCurrentCardFailed();
                                    }, child: Text('NO')),
                                ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _visibleFlashCard = false;
                                      });
                                      //_flashcardController.skew(1,curve: Curves.easeIn,duration: Duration(milliseconds: 1));
                                      await Future.delayed(const Duration(milliseconds: 200));

                                      context.read<ExamCubit>().saveCurrentCardSuccess();
                                    }, child: Text('OK')),
                              ],
                            ),
                          ) : SizedBox.shrink(),
                        )
                      ]
                  );
                } else if(state is LoadingState) {
                  return const Center(
                    child: CircularProgressIndicator()
                  );
                } else {
                  return Container();
                }
              },
              listener: (context, state) {
                if(state is ShowCurrentFlashcardState){
                  setState(() {
                    _flashcardController.skew(1,curve: Curves.easeIn,duration: const Duration(milliseconds: 1));
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
}

class FlashCardPageWidget extends StatelessWidget {
  final String text;

  const FlashCardPageWidget(this.text,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(text,style:TextStyle(fontSize: 20))),
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 10.0, // soften the shadow
          spreadRadius: 1.0, //extend the shadow
          offset: Offset(
            0, // Move to right 10  horizontally
            2.0, // Move to bottom 10 Vertically
          ),
        )
      ]),
      height: 500,
      width: 300,

    );
  }
}

class FlashCardWidget extends StatefulWidget {

  final Flashcard flashcard;
  final BoolCallback? onAnswerShown;
  final FlipCardController controller;
  const FlashCardWidget({required this.flashcard, required this.controller, this.onAnswerShown, Key? key}) : super(key: key);


  @override
  _FlashCardWidgetState createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends State<FlashCardWidget> {

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: FlashCardPageWidget(widget.flashcard.question),
      back: FlashCardPageWidget(widget.flashcard.answer),
      onFlipDone: widget.onAnswerShown,
      controller: widget.controller,
    );
  }
}
