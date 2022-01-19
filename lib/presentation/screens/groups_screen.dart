import 'package:flashcards/config/design_config.dart';
import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';
import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';
import 'package:flashcards/presentation/screens/new_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'group_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupos provisional'),
      ),
      body: BlocBuilder<GroupsCubit, GroupsState>(
        builder: (context, state) {
          print(state);
          if (state is LoadInProgressState) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is LoadSuccessState) {
            final groups = state.groups;

            return ListView.builder(
              padding: DesignConfig.screenPadding,
              itemCount: groups.length,
              itemBuilder: (context, index) =>
                  Card(
                    child: InkWell(
                        child: Container(
                          padding: EdgeInsets.all(16),
                            child: Text(groups[index].name)),
                      onTap: (){
                        Navigator.pushNamed(context, GroupScreen.routeName,arguments: groups[index]);
                      },
                    ),
                  ),
            );
          } else if (state is LoadErrorState) {
            return Container(
              child: Text('GroupsLoadErrorState'),
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        //context.read<GroupsCubit>().
        Navigator.of(context).pushNamed(NewGroupScreen.routeName);
      }),
    );
  }
}
