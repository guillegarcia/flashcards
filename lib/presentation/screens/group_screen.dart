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
        create: (context) => GroupCubit(context.read<SQLiteLocalDatasource>(),group: group),
       child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
          //title: ,
          actions: [
            IconButton(icon: const Icon(Icons.edit),
            onPressed: (){
              Navigator.of(context).pushNamed(EditGroupScreen.routeName,arguments: EditGroupScreenArguments(group: group, groupsCubit: context.read<GroupsCubit>()));
            },)
          ],
        ),
        body: BlocBuilder<GroupCubit, GroupState>(
          builder: (context, state) {
            if (state is LoadFlashcardsInProgressState) {
              return Container(
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (state is LoadFlashcardsSuccessState) {
              final flashcards = state.flashcards;

              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: DesignConfig.screenPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(group.name,style: const TextStyle(
                                fontSize: 32
                            )),
                            const SizedBox(height: 16),
                            Text(group.description!),
                            const SizedBox(height: 32),
                            state.flashcards.isNotEmpty ?
                            Text(AppLocalizations.of(context)!.flashcards, style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey
                            )) : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: flashcards.length,
                          itemBuilder: (context, index) =>
                            Card(
                              child: InkWell(
                                onTap: (){
                                  Navigator.of(context).pushNamed(EditFlashcardScreen.routeName, arguments: EditFlashcardScreenArguments(flashcard: flashcards[index], groupCubit: context.read<GroupCubit>()));
                                },
                                child: Container(
                                  height: 250,
                                  width: 250,
                                  padding: const EdgeInsets.all(16),
                                  child: Center(child: Text(flashcards[index].question,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16))),
                                ),
                              ),
                            ),
                        ),
                      ),
                      state.flashcards.isNotEmpty ?
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:8,horizontal: 16.0),
                          child: OutlinedButton.icon(
                            onPressed: (){
                              Navigator.of(context).pushNamed(NewFlashcardScreen.routeName,arguments: context.read<GroupCubit>());
                            },
                            icon: const Icon(Icons.add),
                            label: Text(AppLocalizations.of(context)!.createFlashcard)),
                        ),
                      ) : const SizedBox.shrink()
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: state.flashcards.isNotEmpty ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.play_arrow),
                              onPressed: (){
                                Navigator.pushNamed(context, ExamScreen.routeName,arguments: state.flashcards);
                              },
                              label: Text(AppLocalizations.of(context)!.startExam.toUpperCase())),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey
                            ),
                              icon: const Icon(Icons.play_arrow_outlined),
                              onPressed: (){
                                Navigator.pushNamed(context, ExamScreen.routeName,arguments: state.reviewFlashcards);
                              },
                              label: Text(AppLocalizations.of(context)!.startFailedExam.toUpperCase()))
                        ],
                      ) : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton.icon(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: (){
                                Navigator.of(context).pushNamed(NewFlashcardScreen.routeName,arguments: context.read<GroupCubit>());
                              },
                              label: Text(AppLocalizations.of(context)!.createFlashcard.toUpperCase())),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                              icon: const Icon(Icons.cloud_download),
                              onPressed: (){
                                Navigator.of(context).pushNamed(ImportScreen.routeName,arguments: context.read<GroupCubit>());
                              },
                              label: Text(AppLocalizations.of(context)!.importFromspreadsheet.toUpperCase()))
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else if (state is LoadFlashcardsErrorState) {
              return Container(
                child: Text('GroupsLoadErrorState'),
              );
            } else {
              return Container();
            }
          },
        )
      )
    );
  }
}
