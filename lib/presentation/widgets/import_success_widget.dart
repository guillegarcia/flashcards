import 'dart:math';

import 'package:flashcards/config/app_config.dart';
import 'package:flashcards/domain/use_cases/import_flashcards_from_csv.dart';
import 'package:flashcards/presentation/widgets/text_and_button_full_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImportSuccessWidget extends StatelessWidget {
  ImportFlashcardsFromCsvResult importResult;

  ImportSuccessWidget({required this.importResult, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //String resultInfoText = '';
    //resultInfoText += 'Importadas: ${importResult.flashcards.length}';
    //if(state.maxFlashcardInGroupReached) resultInfoText +='\nmaxFlashcardInGroupReached';
    //if(state.rowsExceedMaxLengthCounter > 0) resultInfoText +='\nrowsExceedMaxLengthCounter: ${state.rowsExceedMaxLengthCounter}';
    //if(state.rowsWithLessThanTwoColumnsCounter > 0) resultInfoText +='\nrowsWithLessThanTwoColumnsCounter: ${state.rowsWithLessThanTwoColumnsCounter}';

    return TextAndButtonFullPageWidget(
        text: AppLocalizations.of(context)!.importFromSpreadsheetSuccessMessage,
        extraInfo: ImportDetailWidget(importResult),
        buttonText: AppLocalizations.of(context)!.volver.toUpperCase(),
        buttonOnPressed: (){
          //Dos pop pra saltar la selección del tipo de import
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
    );
  }
}

class ImportDetailWidget extends StatelessWidget {
  final ImportFlashcardsFromCsvResult importResult;
  const ImportDetailWidget(this.importResult,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Traducciones
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('IMPORTADAS: ${importResult.flashcards.length}'),
        if(importResult.maxLengthErrorValues.isNotEmpty)
          Text('No se han importado ${importResult.maxLengthErrorValues.length} valores por superar el tamaño máximo permitido'),
      ],
    );
  }
}
