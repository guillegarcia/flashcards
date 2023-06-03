import 'package:flashcards/presentation/screens/import_from_spreadsheet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../config/design_config.dart';
import '../bloc/group/group_cubit.dart';

class ImportScreen extends StatelessWidget {

  final GroupCubit groupCubit;

  const ImportScreen({required this.groupCubit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.importFlashcards),
      ),
      body: Container(
        padding: DesignConfig.screenPadding,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImportOptionWidget(
              optionTitle:AppLocalizations.of(context)!.importFromCSV,
              onTap: (){

              },
            ),
            ImportOptionWidget(
              optionTitle:AppLocalizations.of(context)!.importFromspreadsheet,
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ImportFromSpreadsheetScreen(groupCubit: groupCubit),
                ));
              },
            ),
          ],
        ),
      )
    );
  }

}

class ImportOptionWidget extends StatelessWidget {
  final String optionTitle;
  final GestureTapCallback? onTap;
  const ImportOptionWidget({required this.optionTitle, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black12
          ),
          child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                //splashColor: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16,horizontal: 24),
                    child: Text(optionTitle),
                  )
              )
          )
      ),
    );
  }
}
