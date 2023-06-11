import 'package:flashcards/presentation/screens/import_from_csv_screen.dart';
import 'package:flashcards/presentation/screens/import_from_spreadsheet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              iconData: FontAwesomeIcons.fileCsv,
              color: Colors.blueGrey,
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ImportFromCSVScreen(groupCubit: groupCubit),
                ));
              },
            ),
            ImportOptionWidget(
              optionTitle:AppLocalizations.of(context)!.importFromspreadsheet,
              iconData: FontAwesomeIcons.solidFileExcel,
              color: Color(0xff7FC998),
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
  final IconData iconData;
  final Color color;
  const ImportOptionWidget({required this.color, required this.optionTitle, required this.onTap, required this.iconData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: color
        ),
        child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              //splashColor: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16,horizontal: 24),
                  child: Stack(
                      children: [
                        Align(
                          child:FaIcon(iconData,color: Colors.white,size: 40), // Icon(iconData,color: Colors.white,size: 40),
                          alignment: Alignment.topLeft,
                        ),
                        Align(
                          child: Text(optionTitle,style: TextStyle(color: Colors.white,fontSize: 20)),
                          alignment: Alignment.bottomRight,
                        )
                      ]
                  ) //Text(optionTitle),
                )
            )
        )
    );
  }
}
