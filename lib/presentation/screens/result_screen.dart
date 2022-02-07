import 'package:flashcards/domain/entities/exam_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  static const routeName = '/result_screen';

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {

    ExamResult examResult = ModalRoute.of(context)!.settings.arguments as ExamResult;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text('Resultado'),
            Text('BIEN: ${examResult.rightCounter}'),
            Text('MAL: ${examResult.failedCounter}'),
          ],
        ),
      ),
    );
  }
}
