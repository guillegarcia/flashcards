import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/presentation/bloc/edit_flashcard/edit_flashcard_cubit.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:flashcards/presentation/bloc/new_flashcard/new_flashcard_cubit.dart';
import 'package:flashcards/presentation/widgets/error_message_widget.dart';
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
          if(state is EditFlashcardSuccessState){
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
                }, child: Text(AppLocalizations.of(context)!.save,style: TextStyle(color: Colors.white),))
              ],
            ),
            body:
            (state is EditFlashcardInProgressState)?Center(child: CircularProgressIndicator()):
            Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(AppLocalizations.of(context)!.question),
                  TextFormField(
                      autofocus: true,
                      controller: _questionController,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.valueCanNotBeEmpty;
                        }
                        return null;
                      }
                  ),
                  Text(AppLocalizations.of(context)!.answer),
                  TextFormField(
                      autofocus: true,
                      controller: _answerController,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.valueCanNotBeEmpty;
                        }
                        return null;
                      }
                  ),
                  (state is EditFlashcardErrorState)?ErrorMessageWidget(AppLocalizations.of(context)!.createFlashcardErrorMessage):SizedBox.shrink()
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