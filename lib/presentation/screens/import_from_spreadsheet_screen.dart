import 'package:flashcards/config/design_config.dart';
import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:flashcards/presentation/bloc/import/import_from_spreadsheet_cubit.dart';
import 'package:flashcards/presentation/widgets/form_field_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImportFromSpreadsheetScreen extends StatefulWidget {
  GroupCubit groupCubit;

  ImportFromSpreadsheetScreen({required this.groupCubit, Key? key}) : super(key: key);

  @override
  _ImportFromSpreadsheetScreenState createState() => _ImportFromSpreadsheetScreenState();
}

class _ImportFromSpreadsheetScreenState extends State<ImportFromSpreadsheetScreen> {

  final _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    _urlController.text = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQ-AdUnsxTHpU2XZ_IM9iMs-37Flnjh6ydQtuq0Un-x522PZJTe6Li8rhpj14ZJXjoLFtGpJMMIoOEO/pub?output=csv';

    return BlocProvider(
      create: (context) => ImportFromSpreadsheetCubit(context.read<SQLiteLocalDatasource>(),
          groupBloc: widget.groupCubit
      ),
      child: BlocBuilder<ImportFromSpreadsheetCubit, ImportFromSpreadsheetState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                    AppLocalizations.of(context)!.importFromspreadsheet),
              ),
              body: Container(
                padding: DesignConfig.screenPadding,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      FormFieldLabel(
                          AppLocalizations.of(context)!.spreadsheetUrl),
                      TextFormField(
                          controller: _urlController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .valueCanNotBeEmpty;
                            }
                            return null;
                          }
                      ),
                      SizedBox(height: DesignConfig.formFieldSeparationHeight),
                      ElevatedButton.icon(onPressed: (){
                        if(_formKey.currentState!.validate()) {
                          context.read<ImportFromSpreadsheetCubit>().importFromSpreadsheet('https://docs.google.com/spreadsheets/d/e/2PACX-1vQ-AdUnsxTHpU2XZ_IM9iMs-37Flnjh6ydQtuq0Un-x522PZJTe6Li8rhpj14ZJXjoLFtGpJMMIoOEO/pub?output=csv');
                        }
                      }, icon: const Icon(Icons.cloud_download), label: Text(AppLocalizations.of(context)!.importFlashcards.toUpperCase())),
                      SizedBox(height: DesignConfig.formFieldSeparationHeight),
                      (state is ImportLoadingState)?Center(child: CircularProgressIndicator()):SizedBox.shrink(),
                      (state is ImportSuccessState)?Text('Importadas: ${state.importedFlashcards.length}'):SizedBox.shrink(),
                      (state is ImportSuccessState && state.maxFlashcardInGroupReached)?Text('maxFlashcardInGroupReached'):SizedBox.shrink(),
                      (state is ImportSuccessState && state.rowsExceedMaxLengthCounter > 0)?Text('rowsExceedMaxLengthCounter: ${state.rowsExceedMaxLengthCounter}'):SizedBox.shrink(),
                      (state is ImportSuccessState && state.rowsWithLessThanTwoColumnsCounter > 0)?Text('rowsWithLessThanTwoColumnsCounter: ${state.rowsWithLessThanTwoColumnsCounter}'):SizedBox.shrink(),
                      //(state is DeleteGroupErrorState)?ErrorMessageWidget(AppLocalizations.of(context)!.deleteGroupErrorMessage):SizedBox.shrink()
                    ],
                  ),
                ),
              )
          );
        },
      ),
    );
  }
}
