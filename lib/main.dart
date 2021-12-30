import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'presentation/screens/groups_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/sample_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context)!.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English, no country code
        Locale('es', ''), // Spanish, no country code
      ],
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        SampleScreen.routeName: (context) => SampleScreen(),
        GroupsScreen.routeName: (context) => GroupsScreen(),
      },
      initialRoute: GroupsScreen.routeName,
    );
  }
}
