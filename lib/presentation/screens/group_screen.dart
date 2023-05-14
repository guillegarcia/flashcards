import 'package:flashcards/config/app_config.dart';
import 'package:flashcards/config/design_config.dart';
import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/domain/entities/group.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';
import 'package:flashcards/presentation/screens/edit_flashcard_screen.dart';
import 'package:flashcards/presentation/screens/edit_group_screen.dart';
import 'package:flashcards/presentation/screens/exam_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/entities/exam_data.dart';
import 'import_screen.dart';
import 'new_flashcard_screen.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  static const routeName = '/group_screen';

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  Group? group;

  @override
  Widget build(BuildContext context) {
    if(group == null) group = ModalRoute.of(context)!.settings.arguments as Group;

    return BlocProvider(
        create: (context) =>
            GroupCubit(context.read<SQLiteLocalDatasource>(), group: group!),
        child: BlocBuilder<GroupCubit, GroupState>(
          builder: (context, state) {
              List<Flashcard> flashcards = [];
              List<Flashcard> reviewFlashcards = [];
              if (state is LoadFlashcardsSuccessState) {
                flashcards = state.flashcards;
                reviewFlashcards = state.reviewFlashcards;
              }

              return Scaffold(
                extendBodyBehindAppBar:true,
                appBar: AppBar(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  //title: ,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        var editGroupResult = await Navigator.of(context).pushNamed(EditGroupScreen.routeName,
                            arguments: EditGroupScreenArguments(group: group!,groupsCubit: context.read<GroupsCubit>())
                        );

                        if(editGroupResult!=null && editGroupResult is Group){
                          setState(() {
                            group = editGroupResult as Group;
                          });
                        }
                      },
                    ),
                  ]
                ),
                body: Stack(
                  children: [

                    //###### TEXTO PARA MOSTRAR CUANDO AUN NO HAY TARJETAS
                    if(flashcards.isEmpty) const NoFlashCardsMessageWidget(),

                    //###### LISTA DE TARJETAS PARA EDITAR ######
                    if(flashcards.isNotEmpty) ListView.builder(
                      padding: const EdgeInsets.only(right: 16,left: 16,top: 350,bottom: 24),
                      itemCount: flashcards.length+1,
                      itemBuilder: (context, index) {
                        if(index == 0){
                          return Padding(
                            padding: const EdgeInsets.only(left: 16.0,bottom: 8),
                            child: Text(AppLocalizations.of(context)!.flashcards,style: TextStyle(fontSize: 18)),
                          );
                        }
                        var flashcard = flashcards[index-1];
                        return Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  //splashColor: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          EditFlashcardScreen.routeName,
                                          arguments: EditFlashcardScreenArguments(
                                              flashcard: flashcard,
                                              groupCubit: context.read< GroupCubit>()));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                                      child: Text(flashcard.question,style: const TextStyle(fontWeight: FontWeight.bold)),
                                    )
                                )
                            )
                        );
                      }
                  ),
                  Container(width: double.infinity, height: 220,decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(100),bottomLeft: Radius.circular(100)),
                      color: group!.color
                  )),

                  //###### CABECERA #######
                  Positioned(
                    top: 60,
                    right: 0,
                    left: 0,
                    child: Container(
                      padding: DesignConfig.screenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(group!.name,style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 16),
                          SizedBox(height:45,child: Text(group!.description!)),

                          //####### BOTONES PARA INICIAR REPASO #######
                          StartReviewButtonsWidgets(flashcards: flashcards,reviewFlashcards: reviewFlashcards)
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: flashcards.isNotEmpty
                          ? SizedBox.shrink()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.cloud_download),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(ImportScreen.routeName,arguments:context.read<GroupCubit>());
                                  },
                                  label: Text(AppLocalizations.of(context)!.importFromspreadsheet.toUpperCase())),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.grey),
                                  icon: const Icon(Icons.play_arrow),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(NewFlashcardScreen.routeName,arguments: context.read<GroupCubit>());
                                  },
                                  label: Text(AppLocalizations.of(context)!.createFlashcard.toUpperCase())
                                ),
                              ],
                            ),
                    ),
                  ),
                  (state is LoadFlashcardsInProgressState) ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink()
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.createFlashcard),
                onPressed: (){
                  Navigator.of(context).pushNamed(NewFlashcardScreen.routeName,arguments:context.read<GroupCubit>());
                },
              ),
            );
      }
    )
    );
  }
}

class DoExamButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String label;
  final IconData icon;
  final ExamData examData;
  const DoExamButton({required this.examData,required this.label, required this.icon, this.onTap,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          boxShadow: [
            const BoxShadow(
              color: Colors.grey,
              blurRadius: 6.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: const Offset(
                0.0, // Move to right 10  horizontally
                2.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              //splashColor: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ExamScreen(examData: examData))
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(icon,size: 45),
                      Text(label,style: TextStyle(fontSize: 12),textAlign: TextAlign.center,)
                    ],
                  ),
                  height: 140,
                  width: 100,
                )
            )
        )
    );
  }
}

class NoFlashCardsMessageWidget extends StatelessWidget {
  const NoFlashCardsMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child:Text(AppLocalizations.of(context)!.thereAreNoFlashcards));
  }
}

class StartReviewButtonsWidgets extends StatelessWidget {
  final List<Flashcard> flashcards;
  final List<Flashcard> reviewFlashcards;
  const StartReviewButtonsWidgets({required this.flashcards, required this.reviewFlashcards, Key? key}) : super(key: key);

  final double spaceWidthBetweenButtons = 16;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        flashcards.isNotEmpty ? DoExamButton(
          label: AppLocalizations.of(context)!.startExam.toUpperCase(),
          icon: Icons.play_arrow,
          examData: ExamData(flashcards: flashcards),
        ): const SizedBox.shrink(),
        reviewFlashcards.isNotEmpty ? SizedBox(width: spaceWidthBetweenButtons) : const SizedBox.shrink(),
        reviewFlashcards.isNotEmpty ? DoExamButton(
          label: AppLocalizations.of(context)!.startFailedExam.toUpperCase(),
          icon: Icons.play_arrow_outlined,
          examData: ExamData(flashcards: reviewFlashcards),
        ) : const SizedBox.shrink(),
        flashcards.length>=AppConfig.quickReviewQuestionNumber ? SizedBox(width: spaceWidthBetweenButtons) : const SizedBox.shrink(),
        flashcards.length>=AppConfig.quickReviewQuestionNumber ? DoExamButton(
          label: AppLocalizations.of(context)!.startQuickExam.toUpperCase(),
          icon: Icons.bolt,
          examData: ExamData(flashcards: flashcards,isQuickExam:true),
        ) : const SizedBox.shrink(),
      ],
    );
  }
}

