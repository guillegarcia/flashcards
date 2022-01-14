import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/domain/entities/group.dart';
import 'package:flashcards/presentation/bloc/edit_group/edit_group_cubit.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';
import 'package:flashcards/presentation/bloc/new_group/new_group_cubit.dart';
import 'package:flashcards/presentation/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditGroupScreen extends StatefulWidget {
  const EditGroupScreen({Key? key}) : super(key: key);

  static const routeName = '/edit_group_screen';

  @override
  _EditGroupScreenState createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    EditGroupScreenArguments arguments = ModalRoute.of(context)!.settings.arguments as EditGroupScreenArguments;
    _nameController.text = arguments.group.name;
    _descriptionController.text = arguments.group.description ?? '';

    return BlocProvider(
      create: (context) => EditGroupCubit(context.read<SQLiteLocalDatasource>(),
          groupsBloc: context.read<GroupsCubit>()
      ),
      child: BlocConsumer<EditGroupCubit, EditGroupState>(
        listener: (context, state) {
          if(state is UpdateSuccessState){
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.editGroup),
              actions: [
                TextButton(onPressed: (){
                  if(_formKey.currentState!.validate()) {
                    context.read<EditGroupCubit>().updateGroup(Group(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      id: arguments.group.id
                    ));
                  }
                }, child: Text(AppLocalizations.of(context)!.save,style: TextStyle(color: Colors.white),))
              ],
            ),
            body:
            (state is UpdateInProgressState)?Center(child: CircularProgressIndicator()):
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
                      controller: _descriptionController,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.valueCanNotBeEmpty;
                        }
                        return null;
                      }
                  ),
                  (state is UpdateErrorState)?ErrorMessageWidget(AppLocalizations.of(context)!.updateGroupErrorMessage):SizedBox.shrink()
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

class EditGroupScreenArguments {
  final GroupsCubit groupsCubit;
  final Group group;
  EditGroupScreenArguments({required this.group, required this.groupsCubit});
}