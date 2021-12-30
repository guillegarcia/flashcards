import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';
import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  static const routeName = '/groups_screen';

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<GroupsCubit, GroupsState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is LoadedState) {
            final groups = state.groups;

            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(groups[index].name),
                ),
              ),
            );
          } else if (state is ErrorState) {
            return Container(
              child: Text('GroupsLoadErrorState'),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
