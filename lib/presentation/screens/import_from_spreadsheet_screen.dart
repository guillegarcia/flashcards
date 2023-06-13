import 'package:flashcards/config/design_config.dart';
import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:flashcards/presentation/widgets/form_field_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/import_from_spreadsheet/import_from_spreadsheet_cubit.dart';
import '../widgets/text_and_button_full_page_widget.dart';

class ImportFromSpreadsheetScreen extends StatefulWidget {
  GroupCubit groupCubit;

  ImportFromSpreadsheetScreen({required this.groupCubit, Key? key}) : super(key: key);

  @override
  _ImportFromSpreadsheetScreenState createState() => _ImportFromSpreadsheetScreenState();
}

class _ImportFromSpreadsheetScreenState extends State<ImportFromSpreadsheetScreen> {

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.importFromspreadsheet),
      ),
      body: Container(
        padding: DesignConfig.screenPadding,
        child: BlocProvider(
          create: (context) => ImportFromSpreadsheetCubit(context.read<SQLiteLocalDatasource>(),
            groupBloc: widget.groupCubit
          ),
          child: BlocBuilder<ImportFromSpreadsheetCubit, ImportFromSpreadsheetState>(
            builder: (context, state) {
              if (state is ImportInitialState) {
                return ImportInitialStateContent(formKey: _formKey);
              } else if (state is ImportLoadingState) {
                return const ImportLoadingStateContent();
              } else if (state is ImportSuccessState) {
                return ImportSuccessStateContent(state: state);
              }
              return const ImportErrorStateContent();
            }
          )
        ),
      ),
    );
  }
}

class ImportInitialStateContent extends StatelessWidget {
  final formKey;
  final _urlController = TextEditingController();
  ImportInitialStateContent({required this.formKey, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Quitar
    _urlController.text = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQ-AdUnsxTHpU2XZ_IM9iMs-37Flnjh6ydQtuq0Un-x522PZJTe6Li8rhpj14ZJXjoLFtGpJMMIoOEO/pub?output=csv';
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.importFromSpreadsheetInitialMessage),
              SizedBox(height: DesignConfig.formFieldSeparationHeight),
              Image.asset('assets/images/spreadsheet-sample.png'),
              SizedBox(height: DesignConfig.formFieldSeparationHeight),
              FormFieldLabel(AppLocalizations.of(context)!.spreadsheetUrl),
              TextFormField(
                  controller: _urlController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.valueCanNotBeEmpty;
                    }
                    return null;
                  }
              ),
            ],
          ),

          ElevatedButton(
            onPressed: (){
              if(formKey.currentState!.validate()) {
                context.read<ImportFromSpreadsheetCubit>().importFromSpreadsheet('https://docs.google.com/spreadsheets/d/e/2PACX-1vQ-AdUnsxTHpU2XZ_IM9iMs-37Flnjh6ydQtuq0Un-x522PZJTe6Li8rhpj14ZJXjoLFtGpJMMIoOEO/pub?output=csv');
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50), // NEW
            ),
            child: Text(AppLocalizations.of(context)!.importFlashcards.toUpperCase())
          ),
        ],
      ),
    );
  }
}

class ImportSuccessStateContent extends StatelessWidget {
  final ImportSuccessState state;
  const ImportSuccessStateContent({required this.state, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String resultInfoText = '';
    resultInfoText += 'Importadas: ${state.importedFlashcards.length}';
    if(state.maxFlashcardInGroupReached) resultInfoText +='\nmaxFlashcardInGroupReached';
    if(state.rowsExceedMaxLengthCounter > 0) resultInfoText +='\nrowsExceedMaxLengthCounter: ${state.rowsExceedMaxLengthCounter}';
    if(state.rowsWithLessThanTwoColumnsCounter > 0) resultInfoText +='\nrowsWithLessThanTwoColumnsCounter: ${state.rowsWithLessThanTwoColumnsCounter}';

    return TextAndButtonFullPageWidget(
        text: AppLocalizations.of(context)!.importFromSpreadsheetSuccessMessage,
        subText: resultInfoText,
        buttonText: AppLocalizations.of(context)!.volver.toUpperCase(),
        buttonOnPressed: (){
          //Dos pop pra saltar la selección del tipo de import
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
    );
  }
}


class ImportLoadingStateContent extends StatelessWidget {
  const ImportLoadingStateContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ImportErrorStateContent extends StatelessWidget {
  const ImportErrorStateContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO:
    return const Text('ERROR');
  }
}
