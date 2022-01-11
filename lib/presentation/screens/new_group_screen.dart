import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/domain/entities/group.dart';
import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';
import 'package:flashcards/presentation/bloc/new_group/new_group_cubit.dart';
import 'package:flashcards/presentation/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({Key? key}) : super(key: key);

  static const routeName = '/new_group_screen';

  @override
  _NewGroupScreenState createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => NewGroupCubit(context.read<SQLiteLocalDatasource>(),
        groupsBloc: context.read<GroupsCubit>()
      ),
      child: BlocBuilder<NewGroupCubit, NewGroupState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.newGroup),
              actions: [
                TextButton(onPressed: (){
                  if(_formKey.currentState!.validate()) {
                    var group = Group(
                        name: _nameController.text
                    );
                    context.read<NewGroupCubit>().createGroup(group);
                  }
                }, child: Text(AppLocalizations.of(context)!.save,style: TextStyle(color: Colors.white),))
              ],
            ),
            body:
            (state is CreateInProgressState)?Center(child: CircularProgressIndicator()):
            Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(AppLocalizations.of(context)!.name),
                  TextFormField(
                    autofocus: true,
                    controller: _nameController,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.valueCanNotBeEmpty;
                      }
                      return null;
                    }
                  ),
                  Text(AppLocalizations.of(context)!.description),
                  TextFormField(
                    autofocus: true,
                    controller: _nameController,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.valueCanNotBeEmpty;
                      }
                      return null;
                    }
                  ),
                  (state is CreateErrorState)?ErrorMessageWidget(AppLocalizations.of(context)!.createGroupErrorMessage):SizedBox.shrink()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
