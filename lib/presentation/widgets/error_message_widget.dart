import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String? message;
  const ErrorMessageWidget({this.message,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.somethingWentWrong,
                style: const TextStyle(
                    fontSize: 26
                )
            ),
            const SizedBox(height: 12),
            Text(message!=null ? message! : AppLocalizations.of(context)!.genericErrorMessage,
                style: const TextStyle(
                    fontSize: 16
                )
            )
          ],
        ),
      ),
    );
  }
}
