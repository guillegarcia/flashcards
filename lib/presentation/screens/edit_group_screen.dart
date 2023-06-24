import 'package:flashcards/config/design_config.dart';
import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/domain/entities/group.dart';
import 'package:flashcards/presentation/bloc/edit_group/edit_group_cubit.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';
import 'package:flashcards/presentation/bloc/new_group/new_group_cubit.dart';
import 'package:flashcards/presentation/screens/groups_screen.dart';
import 'package:flashcards/presentation/widgets/color_picker.dart';
import 'package:flashcards/presentation/widgets/error_message_widget.dart';
import 'package:flashcards/presentation/widgets/form_field_label.dart';
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
  Color? _selectedColor;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    EditGroupScreenArguments arguments = ModalRoute
        .of(context)!
        .settings
        .arguments as EditGroupScreenArguments;
    _nameController.text = arguments.group.name;
    _descriptionController.text = arguments.group.description ?? '';
    if (_selectedColor == null) {
      setState(() {
        _selectedColor = arguments.group.color;
      });
    }

    return BlocProvider(
      create: (context) =>
          EditGroupCubit(context.read<SQLiteLocalDatasource>(),
              groupsBloc: context.read<GroupsCubit>()
          ),
      child: BlocConsumer<EditGroupCubit, EditGroupState>(
        listener: (context, state) {
          if (state is UpdateSuccessState) {
            Navigator.of(context).pop(_updatedGroup(arguments.group.id!));
          } else if (state is DeleteGroupSuccessState) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                GroupsScreen.routeName, (Route<dynamic> route) => false);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.editGroup),
              backgroundColor: _selectedColor,
              actions: [
                TextButton(onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<EditGroupCubit>().updateGroup(_updatedGroup(arguments.group.id!));
                  }
                },
                    child: Text(
                        AppLocalizations.of(context)!.save.toUpperCase(),
                        style: TextStyle(color: Colors.black))),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showConfirmationDialog(context, () {
                      context.read<EditGroupCubit>().deleteGroup(
                          arguments.group);
                    });
                  },
                )
              ],
            ),
            body:
            (state is UpdateInProgressState ||
                state is DeleteGroupInProgressState) ? Center(
                child: CircularProgressIndicator()) :
            Container(
              padding: DesignConfig.screenPadding,
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    FormFieldLabel(AppLocalizations.of(context)!.name),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .valueCanNotBeEmpty;
                        }
                        return null;
                      }
                    ),
                    SizedBox(height: DesignConfig.formFieldSeparationHeight),
                    FormFieldLabel(AppLocalizations.of(context)!.color),
                    MyColorPicker(
                        onSelectColor: (value) {
                          setState(() {
                            _selectedColor = value;
                          });
                        },
                        availableColors: DesignConfig.availableColors,
                        initialColor: _selectedColor!),
                    (state is UpdateErrorState)
                        ? ErrorMessageWidget(message:
                        AppLocalizations.of(context)!.updateGroupErrorMessage)
                        : SizedBox.shrink(),
                    (state is DeleteGroupErrorState)
                        ? ErrorMessageWidget(message:
                        AppLocalizations.of(context)!.deleteGroupErrorMessage)
                        : SizedBox.shrink()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Group _updatedGroup(int groupId){
    return Group(
      name: _nameController.text,
      description: _descriptionController.text,
      color: _selectedColor!,
      id: groupId,
    );
  }

  void showConfirmationDialog(BuildContext context,VoidCallback mainAction) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(AppLocalizations.of(context)!.cancel),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(AppLocalizations.of(context)!.delete),
      onPressed:  (){
        Navigator.pop(context);
        mainAction();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(AppLocalizations.of(context)!.confirmationMessageDeleteGroup),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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