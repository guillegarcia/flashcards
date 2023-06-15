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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GroupsHeaderWidget(),
          Expanded(
            child: BlocBuilder<GroupsCubit, GroupsState>(
              builder: (context, state) {
                if (state is LoadInProgressState) {
                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is LoadSuccessState) {
                  final groups = state.groups;
                  MediaQueryData queryData = MediaQuery.of(context);
                  double setWidth = queryData.size.width / 2 - DesignConfig.screenPadding.horizontal;
                  double setHeight = 150;
                  final setborder = RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  );
                  return ListView(
                    padding: DesignConfig.screenPadding,
                    children: List.generate(groups.length, (index) {
                      Group group = groups[index];
                      return SetWidget(group);
                    })
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        //context.read<GroupsCubit>().
        Navigator.of(context).pushNamed(NewGroupScreen.routeName);
      }),
    );
  }
}

class GroupsHeaderWidget extends StatelessWidget {
  const GroupsHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60,bottom: 28,left: 24,right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.flashcardsGroupsTitle,
            style: const TextStyle(
              fontSize: 32
            )
          ),
          const SizedBox(height: 4),
          Text(AppLocalizations.of(context)!.flashcardsGroupsSubTitle,
            style: const TextStyle(
              fontSize: 18
            )
          )
        ],
      ),
    );
  }
}

class SetWidget extends StatelessWidget {
  Group set;
  SetWidget(this.set,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: set.color
        ),
        child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              //splashColor: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                onTap: () {
                  Navigator.pushNamed(context, GroupScreen.routeName,arguments: set);
                },
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 24),
                  child: Text(set.name,style: const TextStyle(fontSize: 18,color: Colors.white)),
                  height: 150,
                )
            )
        )
    );
  }
}
