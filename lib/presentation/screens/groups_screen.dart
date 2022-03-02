import 'package:flashcards/config/design_config.dart';
import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/group.dart';
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
        title: Text(AppLocalizations.of(context)!.flashcardsGroups),
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
            MediaQueryData queryData = MediaQuery.of(context);
            double deckWidth = queryData.size.width / 2 - DesignConfig.screenPadding.horizontal;
            double deckHeight = 150;
            final deckborder = RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            );
            return ListView(
              children: List.generate(groups.length, (index) {
                Group group = groups[index];
                return Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: group.color
                    ),
                    child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          //splashColor: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            onTap: () {
                              Navigator.pushNamed(context, GroupScreen.routeName,arguments: group);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 24),
                              child: Text(group.name,style: const TextStyle(fontSize: 18)),
                              height: 150,
                            )
                        )
                    )
                );
              })
            );
            return groups.length > 0 ? GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(groups.length, (index) {
                Group group = groups[index];
                return Stack(
                  children: [
                    Positioned(
                      top: 10,
                      child: Card(
                        shape: deckborder,
                        child: SizedBox(
                          width: deckWidth,
                          height: deckHeight,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      child: Card(
                        shape: deckborder,
                        child: SizedBox(
                          width: deckWidth,
                          height: deckHeight,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Card(
                        shape: deckborder,
                        child: InkWell(
                          child: Container(
                              width: deckWidth,
                              height: deckHeight,
                              padding: const EdgeInsets.all(16),
                              child: Center(child: Text(group.name))),
                          onTap: (){
                            Navigator.pushNamed(context, GroupScreen.routeName,arguments: group);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
              padding: DesignConfig.screenPadding,
            ) : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0,horizontal: 48),
                  child: Text(AppLocalizations.of(context)!.thereAreNoGroups,style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,),
                ),
                Text('😉',style: TextStyle(fontSize: 40),)
              ],
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
