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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        create: (context) => GroupCubit(context.read<SQLiteLocalDatasource>(),group: group),
       child: Scaffold(
        appBar: AppBar(
          title: Text(group.name),
          actions: [
            IconButton(icon: Icon(Icons.edit),
            onPressed: (){
              Navigator.of(context).pushNamed(EditGroupScreen.routeName,arguments: EditGroupScreenArguments(group: group, groupsCubit: context.read<GroupsCubit>()));
            },)
          ],
        ),
        body: BlocBuilder<GroupCubit, GroupState>(
          builder: (context, state) {
            if (state is LoadFlashcardsInProgressState) {
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is LoadFlashcardsSuccessState) {
              final flashcards = state.flashcards;

              return Container(
                padding: DesignConfig.screenPadding,
                child: Column(
                  children: [
                    Text(group.description!),
                    ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, ExamScreen.routeName,arguments: group.cards);
                    }, child: Text(AppLocalizations.of(context)!.startExam)),
                    Expanded(
                      child: ListView.builder(
                        itemCount: flashcards.length,
                        itemBuilder: (context, index) =>
                            Card(
                              child: InkWell(
                                onTap: (){
                                  Navigator.of(context).pushNamed(EditFlashcardScreen.routeName,arguments: EditFlashcardScreenArguments(flashcard: flashcards[index], groupCubit: context.read<GroupCubit>()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Text(flashcards[index].question,style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(flashcards[index].answer),
                                    ],
                                  )
                                ),
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is LoadFlashcardsErrorState) {
              return Container(
                child: Text('GroupsLoadErrorState'),
              );
            } else {
              return Container();
            }
          },
        ),
        floatingActionButton: BlocBuilder<GroupCubit, GroupState>(
          builder:(context, state) {
          return FloatingActionButton.extended(
              label: Text(AppLocalizations.of(context)!.createFlashcard),
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.of(context).pushNamed(NewFlashcardScreen.routeName,arguments: context.read<GroupCubit>());
              }
            );
          }
        ),
      )
    );
  }
}
