import 'package:flashcards/config/app_config.dart';
import 'package:flashcards/config/design_config.dart';
import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/presentation/bloc/edit_flashcard/edit_flashcard_cubit.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:flashcards/presentation/widgets/error_message_widget.dart';
import 'package:flashcards/presentation/widgets/form_field_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditFlashcardScreen extends StatefulWidget {
  const EditFlashcardScreen({Key? key}) : super(key: key);

  static const routeName = '/edit_Flashcard_screen';

  @override
  _EditFlashcardScreenState createState() => _EditFlashcardScreenState();
}

class _EditFlashcardScreenState extends State<EditFlashcardScreen> {

  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    EditFlashcardScreenArguments arguments = ModalRoute.of(context)!.settings.arguments as EditFlashcardScreenArguments;
    _questionController.text = arguments.flashcard.question;
    _answerController.text = arguments.flashcard.answer;

    return BlocProvider(
      create: (context) => EditFlashcardCubit(context.read<SQLiteLocalDatasource>(),
          groupBloc: arguments.groupCubit
      ),
      child: BlocConsumer<EditFlashcardCubit, EditFlashcardState>(
        listener: (context, state) {
          if(state is EditFlashcardSuccessState || state is DeleteFlashcardSuccessState){
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.editFlashcard),
              actions: [
                TextButton(onPressed: (){
                  if(_formKey.currentState!.validate()) {
                    var flashcard = Flashcard(
                      id: arguments.flashcard.id,
                      question: _questionController.text,
                      answer: _answerController.text
                    );
                    context.read<EditFlashcardCubit>().editFlashcard(flashcard);
                  }
                }, child: Text(AppLocalizations.of(context)!.save.toUpperCase(),style: const TextStyle(color: Colors.black))),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: (){
                    showConfirmationDialog(context,(){
                      context.read<EditFlashcardCubit>().deleteFlashcard(arguments.flashcard);
                    });
                  },
                )
              ],
            ),
            body:
            (state is EditFlashcardInProgressState || state is DeleteFlashcardInProgressState)? const Center(child: CircularProgressIndicator()):
            Container(
              padding: DesignConfig.screenPadding,
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    FormFieldLabel(AppLocalizations.of(context)!.question),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      maxLength: AppConfig.flashcardTextMaxLength,
                      controller: _questionController,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.valueCanNotBeEmpty;
                        }
                        return null;
                      }
                    ),
                    SizedBox(height: DesignConfig.formFieldSeparationHeight),
                    FormFieldLabel(AppLocalizations.of(context)!.answer),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      maxLength: AppConfig.flashcardTextMaxLength,
                      controller: _answerController,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.valueCanNotBeEmpty;
                        }
                        return null;
                      }
                    ),
                    (state is EditFlashcardErrorState) ? ErrorMessageWidget(message:AppLocalizations.of(context)!.updateFlashcardErrorMessage) : const SizedBox.shrink(),
                    (state is DeleteFlashcardErrorState) ? ErrorMessageWidget(message:AppLocalizations.of(context)!.deleteFlashcardErrorMessage): const SizedBox.shrink()
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
      content: Text(AppLocalizations.of(context)!.confirmationMessageDeleteFlashcard),
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
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }
}

class EditFlashcardScreenArguments {
  final GroupCubit groupCubit;
  final Flashcard flashcard;
  EditFlashcardScreenArguments({required this.flashcard, required this.groupCubit});
}