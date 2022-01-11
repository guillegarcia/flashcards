import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:flashcards/presentation/bloc/new_flashcard/new_flashcard_cubit.dart';
import 'package:flashcards/presentation/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewFlashcardScreen extends StatefulWidget {
  const NewFlashcardScreen({Key? key}) : super(key: key);

  static const routeName = '/new_Flashcard_screen';

  @override
  _NewFlashcardScreenState createState() => _NewFlashcardScreenState();
}

class _NewFlashcardScreenState extends State<NewFlashcardScreen> {

  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    GroupCubit groupCubit = ModalRoute.of(context)!.settings.arguments as GroupCubit;

    return BlocProvider(
      create: (context) => NewFlashcardCubit(context.read<SQLiteLocalDatasource>(),
         groupBloc: groupCubit
      ),
      child: BlocBuilder<NewFlashcardCubit, NewFlashcardState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.createFlashcard),
              actions: [
                TextButton(onPressed: (){
                  if(_formKey.currentState!.validate()) {
                    var flashcard = Flashcard(
                        question: _questionController.text,
                      answer: _answerController.text
                    );
                    context.read<NewFlashcardCubit>().createFlashcard(flashcard);
                  }
                }, child: Text(AppLocalizations.of(context)!.save,style: TextStyle(color: Colors.white),))
              ],
            ),
            body:
            (state is CreateFlashcardInProgressState)?Center(child: CircularProgressIndicator()):
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
                  (state is CreateFlashcardErrorState)?ErrorMessageWidget(AppLocalizations.of(context)!.createFlashcardErrorMessage):SizedBox.shrink()
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
