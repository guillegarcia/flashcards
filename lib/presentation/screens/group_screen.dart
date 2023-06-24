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
import 'package:flashcards/presentation/screens/export_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../domain/entities/exam_data.dart';
import 'import_screen.dart';
import 'new_flashcard_screen.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  static const routeName = '/group_screen';

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> with SingleTickerProviderStateMixin{
  Group? group;
  bool _reviewButtonsVisible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _reviewButtonsVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    group = ModalRoute.of(context)!.settings.arguments as Group;

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
                    if (flashcards.isNotEmpty) PopupMenuButton(
                      // add icon, by default "3 dot" icon
                      // icon: Icon(Icons.book)
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'export',
                            child: Text(AppLocalizations.of(context)!.exportFlashcards),
                          ),
                          PopupMenuItem<String>(
                            value: 'import',
                            child: Text(AppLocalizations.of(context)!.importFlashcards),
                          ),
                        ];
                      },
                      onSelected: (String value) {
                        switch (value) {
                          case 'export':
                             Navigator.of(context).push(MaterialPageRoute(
                                 builder: (context) => ExportScreen(flashcards: flashcards),
                             ));
                             break;
                          case 'import':
                            GroupCubit groupCubit = context.read<GroupCubit>();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ImportScreen(groupCubit: groupCubit),
                            ));
                        }
                      },
                    )
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
                            padding: const EdgeInsets.only(left: 16.0,bottom: 8,right: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.of(context)!.flashcards,style: const TextStyle(fontSize: 18)),
                                Text('${flashcards.length}/${AppConfig.maxFlashcardInGroup}',style: const TextStyle(fontSize: 14, color:Colors.black12)),
                              ],
                            ),
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
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                  Hero(
                    tag: 'set${group!.id!}',
                    child: Container(width: double.infinity, height: 220,decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(100),bottomLeft: Radius.circular(100)),
                        color: group!.color
                    )),
                  ),

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
                          Text(group!.name,style: const TextStyle(fontSize: 32,color: Colors.white)),
                          const SizedBox(height: 40),
                          //SizedBox(height:45,child: Text(group!.description!,style: const TextStyle(color: Colors.white),)),
                          //####### BOTONES PARA INICIAR REPASO #######
                          AnimatedOpacity(
                            opacity: _reviewButtonsVisible ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: StartReviewButtonsWidgets(flashcards: flashcards,reviewFlashcards: reviewFlashcards)
                          )
                        ],
                      ),
                    ),
                  ),
                  (state is LoadFlashcardsInProgressState) ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink()
                ],
              ),
              floatingActionButton: (state is LoadFlashcardsSuccessState) ?
                  (flashcards.length < AppConfig.maxFlashcardInGroup) ? GroupFAB(showImportButton: flashcards.isEmpty, groupCubit: context.read<GroupCubit>(),) : const SizedBox.shrink()
                  : const SizedBox.shrink(),
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
                  padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FaIcon(icon,size: 35),
                      Text(label,style: const TextStyle(fontSize: 12),textAlign: TextAlign.center)
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
          icon: FontAwesomeIcons.play,
          examData: ExamData(flashcards: flashcards),
        ): const SizedBox.shrink(),
        reviewFlashcards.isNotEmpty ? SizedBox(width: spaceWidthBetweenButtons) : const SizedBox.shrink(),
        reviewFlashcards.isNotEmpty ? DoExamButton(
          label: AppLocalizations.of(context)!.startFailedExam.toUpperCase(),
          icon: FontAwesomeIcons.repeat,
          examData: ExamData(flashcards: reviewFlashcards),
        ) : const SizedBox.shrink(),
        flashcards.length>=AppConfig.quickReviewQuestionNumber ? SizedBox(width: spaceWidthBetweenButtons) : const SizedBox.shrink(),
        flashcards.length>=AppConfig.quickReviewQuestionNumber ? DoExamButton(
          label: AppLocalizations.of(context)!.startQuickExam.toUpperCase(),
          icon: FontAwesomeIcons.bolt,
          examData: ExamData(flashcards: flashcards,isQuickExam:true),
        ) : const SizedBox.shrink(),
      ],
    );
  }
}

class GroupFAB extends StatelessWidget {
  bool showImportButton;
  GroupCubit groupCubit;
  GroupFAB({required this.groupCubit, this.showImportButton = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(showImportButton) {
      return Wrap(
        direction: Axis.vertical,
        children: [
          const FabCreateFlashcard(),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            heroTag: 'import',//Cuando hay varios FAB y un Hero en la página se lia si no le ponemos un heroTag único a cada FAB y da un error
            label: Text(AppLocalizations.of(context)!.importFlashcards),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ImportScreen(groupCubit: groupCubit),
              ));
            },
          ),
        ],
      );
    }
    return const FabCreateFlashcard();
  }
}

class FabCreateFlashcard extends StatelessWidget {
  const FabCreateFlashcard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.add),
      heroTag: 'create',//Cuando hay varios FAB y un Hero en la página se lia si no le ponemos un heroTag único a cada FAB y da un error
      label: Text(AppLocalizations.of(context)!.createFlashcard),
      onPressed: () {
        Navigator.of(context).pushNamed(NewFlashcardScreen.routeName,
            arguments: context.read<GroupCubit>());
      },
    );
  }
}
