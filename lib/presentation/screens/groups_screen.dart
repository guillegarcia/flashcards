import 'package:flashcards/config/design_config.dart';
import 'package:flashcards/domain/entities/group.dart';
import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';
import 'package:flashcards/presentation/screens/new_group_screen.dart';
import 'package:flashcards/presentation/widgets/error_message_widget.dart';
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
      body: BlocBuilder<GroupsCubit, GroupsState>(
        builder: (context, state) {
          if (state is LoadInProgressState) {
            return const LoadInProgressContent();
          } else if (state is LoadSuccessState) {
            return LoadSuccessContent(state);
          } else if (state is LoadErrorState) {
            return const ErrorMessageWidget();
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.add),onPressed: (){
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
  Group group;
  SetWidget(this.group,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'set${group.id!}',
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: group.color
        ),
        child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupScreen(group),
                ));
              },
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 24),
                child: Text(group.name,style: const TextStyle(fontSize: 18,color: Colors.white)),
                height: 150,
              ),
            )
        )
      )
    );
  }
}

class LoadInProgressContent extends StatelessWidget {
  const LoadInProgressContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class LoadSuccessContent extends StatelessWidget {
  final LoadSuccessState state;
  const LoadSuccessContent(this.state,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groups = state.groups;
    if(groups.isEmpty){
      return const NoGroupMessageWidget();
    } else {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GroupsHeaderWidget(),
            Expanded(
                child: ListView(
                    padding: DesignConfig.screenPadding,
                    children: List.generate(groups.length, (index) {
                      Group group = groups[index];
                      return SetWidget(group);
                    })
                )
            )
          ]
      );
    }
  }
}

class NoGroupMessageWidget extends StatelessWidget {
  const NoGroupMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.noGroupsTitle+' 🙂',
                style: const TextStyle(
                    fontSize: 32
                )
            ),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.noGroupsMessage,
                style: const TextStyle(
                    fontSize: 18
                )
            )
          ],
        ),
      ),
    );
  }
}