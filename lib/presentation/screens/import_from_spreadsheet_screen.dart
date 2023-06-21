import 'package:flashcards/config/design_config.dart';
import 'package:flashcards/data/datasources/sqlite_local_datasource.dart';
import 'package:flashcards/presentation/bloc/group/group_cubit.dart';
import 'package:flashcards/presentation/widgets/form_field_label.dart';
import 'package:flashcards/presentation/widgets/import_success_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/import_from_spreadsheet/import_from_spreadsheet_cubit.dart';

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
    //_urlController.text = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQ-AdUnsxTHpU2XZ_IM9iMs-37Flnjh6ydQtuq0Un-x522PZJTe6Li8rhpj14ZJXjoLFtGpJMMIoOEO/pub?output=csv';
    _urlController.text = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vSHZYd6sGhJuLAmeX02pi43fTumUY9QKQFbbzMctP4oYuGSOymRvs9NnGKwAaJTtzDPGH8vrih3J3Tk/pub?output=csv&cache=2';

    //Archivo -> Compartir -> publicar en web
    //"Valores separados por comas (csv)"
    //Copia el enlace y pégalo aquí

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                Text(AppLocalizations.of(context)!.importFromSpreadsheetInitialMessage),
                SizedBox(height: DesignConfig.formFieldSeparationHeight),
                const ImageWithBorder('assets/images/spreadsheet-sample.png'),
                SizedBox(height: DesignConfig.formFieldSeparationHeight),
                Text(AppLocalizations.of(context)!.importFromSpreadsheetInitialMessagePart2),
                SizedBox(height: DesignConfig.formFieldSeparationHeight),
                const ImageWithBorder('assets/images/spreadsheet-publish.png'),
                SizedBox(height: DesignConfig.formFieldSeparationHeight),
                Text(AppLocalizations.of(context)!.importFromSpreadsheetInitialMessagePart3),
                SizedBox(height: DesignConfig.formFieldSeparationHeight),
                const ImageWithBorder('assets/images/spreadsheet-publish2.png'),
                SizedBox(height: DesignConfig.formFieldSeparationHeight),
              ],
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.only(top:32),
            child: ElevatedButton(
              onPressed: (){
                if(formKey.currentState!.validate()) {
                  context.read<ImportFromSpreadsheetCubit>().importFromSpreadsheet(_urlController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // NEW
              ),
              child: Text(AppLocalizations.of(context)!.importFlashcards.toUpperCase())
            ),
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
    return ImportSuccessWidget(importResult: state.importResult);
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

class ImageWithBorder extends StatelessWidget {
  final String imagePath;
  const ImageWithBorder(this.imagePath,{ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Color del borde
          width: 2.0, // Ancho del borde
        ),
      ),
      child: Image.asset(imagePath),
    );
  }
}
