import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/domain/entities/group.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
      ),
      body: BlocProvider(
        create: (context) => GroupCubit(context.read<SQLiteLocalDatasource>(),
        group: group),
        child: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state is LoadFlashcardsInProgressState) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is LoadFlashcardsSuccessState) {
            final flashcards = state.flashcards;

            return ListView.builder(
              itemCount: flashcards.length,
              itemBuilder: (context, index) =>
                  Card(
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
),
      floatingActionButton: FloatingActionButton(child: Text(AppLocalizations.of(context)!.createFlashcard),onPressed: (){
        //context.read<GroupsCubit>().
        //Navigator.of(context).pushNamed(NewFlashcardScreen.routeName);
      }),
    );
  }
}