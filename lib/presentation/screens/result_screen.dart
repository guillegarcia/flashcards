import 'package:flashcards/config/design_config.dart';
import 'package:flashcards/domain/entities/exam_result.dart';
import 'package:flashcards/utils/admob_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../domain/entities/exam_data.dart';
import 'exam_screen.dart';
import 'groups_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  static const routeName = '/result_screen';

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  AdmobTools? admobTools;

  @override
  void initState() {
    admobTools = AdmobTools();
    admobTools!.adAction();
    super.initState();
  }

  @override
  void dispose() {
    admobTools!.disposeInterstitialAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ExamResult examResult = ModalRoute.of(context)!.settings.arguments as ExamResult;
    int totalSteps = examResult.failedFlashcard.length +examResult.rightCounter;
    double percent = double.parse((100*examResult.rightCounter/(totalSteps)).toStringAsFixed(2));
    admobTools!.screenIsReadyToShowAd();

    return Scaffold(
      body: Padding(
        padding: DesignConfig.screenPadding,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 56),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                    child: Text(AppLocalizations.of(context)!.result,
                      style: const TextStyle(fontSize: 30),
                    )
                ),
                const SizedBox(height: 24),
                CircularStepProgressIndicator(
                  totalSteps: totalSteps,
                  currentStep: examResult.rightCounter,
                  stepSize: 25,
                  selectedColor: _resultColor(examResult.rightCounter,totalSteps),
                  unselectedColor: Colors.grey[200],
                  padding: 0,
                  width: 250,
                  height: 250,
                  selectedStepSize: 25,
                  roundedCap: (_, __) => true,
                  child: Center(child: Text('$percent%',style: const TextStyle(fontSize: 40),)),
                ),
                const SizedBox(height: 24),
                Text('${examResult.rightCounter} / $totalSteps',style: const TextStyle(color: Colors.grey, fontSize: 30),)
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0,left: 16,right: 16),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    examResult.failedFlashcard.isNotEmpty ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 8),
                      child: ElevatedButton(
                        child: Text((AppLocalizations.of(context)!.repeatFailedCards).toUpperCase(),style: const TextStyle(fontSize: 18)),
                        onPressed: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ExamScreen(
                                examData: ExamData(flashcards: examResult.failedFlashcard)
                            ))
                          );
                        },
                      ),
                    ) : const SizedBox.shrink(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text((AppLocalizations.of(context)!.goHome).toUpperCase(),style: const TextStyle(fontSize: 18)),
                        onPressed: (){
                          Navigator.pushNamedAndRemoveUntil(context, GroupsScreen.routeName, (route) => false);
                        },
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  Color _resultColor(int rightCounter, int totalSteps) {
    double minimumToPass = totalSteps/2;
    if(rightCounter>=minimumToPass){
      return Colors.green;
    }
    return Colors.black54;
  }
}
