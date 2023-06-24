import 'package:flashcards/config/app_config.dart';
import 'package:flashcards/config/design_config.dart';
import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:flashcards/presentation/bloc/new_flashcard/new_flashcard_cubit.dart';
import 'package:flashcards/presentation/widgets/error_message_widget.dart';
import 'package:flashcards/presentation/widgets/form_field_label.dart';
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
      child: BlocConsumer<NewFlashcardCubit, NewFlashcardState>(
        listener: (context, state) {
          if(state is CreateFlashcardSuccessState){
            Navigator.of(context).pop();
          }
        },
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
                }, child: Text(AppLocalizations.of(context)!.save.toUpperCase(),style: TextStyle(color: Colors.black),))
              ],
            ),
            body:
            (state is CreateFlashcardInProgressState)?Center(child: CircularProgressIndicator()):
            Container(
              padding: DesignConfig.screenPadding,
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    FormFieldLabel(AppLocalizations.of(context)!.question),
                    TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        autofocus: true,
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
                    (state is CreateFlashcardErrorState)?ErrorMessageWidget(message: AppLocalizations.of(context)!.createFlashcardErrorMessage):SizedBox.shrink()
                  ],
                ),
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
