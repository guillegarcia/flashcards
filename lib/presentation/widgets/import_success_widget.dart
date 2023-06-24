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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.importDetail,style: const TextStyle(fontWeight: FontWeight.bold,decoration: TextDecoration.underline)),
        if(importResult.flashcardsCreatedCounter>0)
          Text('- ${importResult.flashcardsCreatedCounter} ${AppLocalizations.of(context)!.createdFlashcardsImportMessage}'),
        if(importResult.flashcardsRepeatedCounter>0)
          Text('- ${importResult.flashcardsRepeatedCounter} ${AppLocalizations.of(context)!.repeatedFlashcardsImportMessage}'),
        if(importResult.maxLengthErrorCounter>0)
          Text('- ${importResult.maxLengthErrorCounter} ${AppLocalizations.of(context)!.maxLengthErrorImportMessage} (${AppConfig.flashcardTextMaxLength})'),
        if(importResult.flashcardsLimitReached)
          Text('- ${AppLocalizations.of(context)!.flashcardsLimitReachedImportMessage} (${AppConfig.maxFlashcardInGroup})'),
      ],
    );
  }
}
