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
  ExamResult examResult;

  ResultScreen({required this.examResult, Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {

  AdmobTools? admobTools;
  late Animation<int> animation;
  late AnimationController controller;
  late int totalSteps;
  late int percent;

  @override
  void initState() {
    //Admob
    admobTools = AdmobTools();
    admobTools!.adAction();
    super.initState();

    //Init data
    totalSteps = widget.examResult.failedFlashcard.length + widget.examResult.rightCounter;
    percent =(100 * widget.examResult.rightCounter / (totalSteps)).round();

    //Animacion
    controller = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    animation = IntTween(begin: 1, end: widget.examResult.rightCounter).animate(controller)..addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  void dispose() {
    admobTools!.disposeInterstitialAd();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    admobTools!.screenIsReadyToShowAd();

    return Scaffold(
      backgroundColor: widget.examResult.color,
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
                  currentStep: animation.value,
                  stepSize: 25,
                  selectedColor: Colors.white,
                  unselectedColor: Colors.grey,
                  padding: 0,
                  width: 250,
                  height: 250,
                  selectedStepSize: 25.0,
                  roundedCap: (_, __) => true,
                  child: Center(child: Text('$percent%',style: const TextStyle(fontSize: 40,color: Colors.white),)),
                ),
                const SizedBox(height: 24),
                Text('${animation.value} / $totalSteps',style: const TextStyle(color: Colors.white, fontSize: 30),)
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
                    widget.examResult.failedFlashcard.isNotEmpty ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 8),
                      child: ElevatedButton(
                        child: Text((AppLocalizations.of(context)!.repeatFailedCards).toUpperCase(),style: const TextStyle(fontSize: 18)),
                        onPressed: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ExamScreen(
                                examData: ExamData(flashcards: widget.examResult.failedFlashcard)
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
}
