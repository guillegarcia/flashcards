import 'package:flashcards/config/design_config.dart';
import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
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

import 'import_screen.dart';
import 'new_flashcard_screen.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  static const routeName = '/group_screen';

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {

  @override
  Widget build(BuildContext context) {
    Group group = ModalRoute.of(context)!.settings.arguments as Group;

    return BlocProvider(
        create: (context) =>
            GroupCubit(context.read<SQLiteLocalDatasource>(), group: group),
        child: BlocBuilder<GroupCubit, GroupState>(
          builder: (context, state) {
              var flashcards = [];
              var reviewFlashcards = [];
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
                      onPressed: () {
                        Navigator.of(context).pushNamed(EditGroupScreen.routeName,
                            arguments: EditGroupScreenArguments(group: group,groupsCubit: context.read<GroupsCubit>())
                        );
                      },
                    )
                  ],
                ),
                body: Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(right: 16,left: 16,top: 350,bottom: 24),
                      //scrollDirection: Axis.horizonta,
                      itemCount: flashcards.length,
                      itemBuilder: (context, index) {
                        var flashcard = flashcards[index];
                        return Container(
                            margin: EdgeInsets.all(8),
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
                                              flashcard: flashcards[index],
                                              groupCubit: context.read< GroupCubit>()));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 24, horizontal: 24),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(flashcard.question,style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(flashcard.answer),
                                        ],
                                      ),
                                    )
                                )
                            )
                        );
                      }
                  ),
                  Hero(
                    child: Container(width: double.infinity, height: 220,decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(90),bottomLeft: Radius.circular(90)),
                        color: group.color
                    )),
                    tag: group.id!
                  ),
                  Positioned(
                    top: 60,
                    right: 0,
                    left: 0,
                    child: Container(
                      padding: DesignConfig.screenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(group.name,style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 16),
                          Container(height:45,child: Text(group.description!)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const GroupButton(),
                              const SizedBox(width: 16),
                              const GroupButton(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: flashcards.isNotEmpty
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton.icon(
                                    icon: const Icon(Icons.play_arrow),
                                    onPressed: () {
                                      Navigator.pushNamed(context, ExamScreen.routeName,arguments: flashcards);
                                    },
                                    label: Text(AppLocalizations.of(context)!.startExam.toUpperCase())),
                                const SizedBox(height: 12),
                                (reviewFlashcards.isNotEmpty)
                                    ? ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(primary: Colors.grey),
                                        icon: const Icon(Icons.play_arrow_outlined),
                                        onPressed: () {
                                          Navigator.pushNamed(context, ExamScreen.routeName,arguments:reviewFlashcards);
                                        },
                                        label: Text(AppLocalizations.of(context)!.startFailedExam.toUpperCase()))
                                    : SizedBox.shrink()
                              ],
                            )
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
                                    Navigator.of(context).pushNamed(
                                        NewFlashcardScreen.routeName,
                                        arguments: context.read<GroupCubit>());
                                  },
                                  label: Text(AppLocalizations.of(context)!.createFlashcard.toUpperCase())
                                ),
                              ],
                            ),
                    ),
                  ),
                  (state is LoadFlashcardsInProgressState) ? const Center(child: CircularProgressIndicator()) : SizedBox.shrink()
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                icon: Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.createFlashcard),
                onPressed: (){
                  Navigator.of(context).pushNamed(
                      NewFlashcardScreen.routeName,
                      arguments:
                      context.read<GroupCubit>());
                },
              ),
            );
      }
    )
    );
  }
}

class GroupButton extends StatelessWidget {
  const GroupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: Offset(
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
                borderRadius: BorderRadius.all(Radius.circular(20)),
                onTap: () {

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.play_arrow,size: 40),
                      Text(AppLocalizations.of(context)!.startExam.toUpperCase())
                    ],
                  ),
                  height: 120,
                  width: 120,
                )
            )
        )
    );
  }
}

