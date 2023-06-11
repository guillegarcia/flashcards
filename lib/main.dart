import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';
import 'package:flashcards/presentation/screens/new_flashcard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'data/datasources/sqlite_local_datasource.dart';
import 'presentation/screens/edit_flashcard_screen.dart';
import 'presentation/screens/edit_group_screen.dart';
import 'presentation/screens/exam_screen.dart';
import 'presentation/screens/group_screen.dart';
import 'presentation/screens/groups_screen.dart';
import 'presentation/screens/import_screen.dart';
import 'presentation/screens/new_group_screen.dart';
import 'presentation/screens/result_screen.dart';
import 'presentation/screens/sample_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final ThemeData theme = ThemeData();

    return RepositoryProvider(
      create: (context) => SQLiteLocalDatasource(),
      child: BlocProvider(
        create: (context) => GroupsCubit(context.read<SQLiteLocalDatasource>()),
        child: MaterialApp(
          title: 'Simple flashcards',
          theme: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                  primary: Colors.black,
                  secondary: Colors.black,
                  //onPrimary: Colors.black
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black
              ),
              inputDecorationTheme: new InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    // width: 0.0 produces a thin "hairline" border
                    borderSide: const BorderSide(color: Colors.black54, width: 0.0),
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    // width: 0.0 produces a thin "hairline" border
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  hintStyle: TextStyle(color: Colors.grey[800])
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    elevation: 6,
                    padding: EdgeInsets.symmetric(vertical: 16,horizontal: 28),
                    textStyle: TextStyle(fontSize: 14),
                    shape:RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  )
              )
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
            SampleScreen.routeName: (context) => SampleScreen(),
            GroupsScreen.routeName: (context) => GroupsScreen(),
            NewGroupScreen.routeName: (context) => NewGroupScreen(),
            NewFlashcardScreen.routeName: (context) => NewFlashcardScreen(),
            EditFlashcardScreen.routeName: (context) => EditFlashcardScreen(),
            GroupScreen.routeName: (context) => GroupScreen(),
            EditGroupScreen.routeName: (context) => EditGroupScreen(),
            ResultScreen.routeName: (context) => ResultScreen(),
          },
          initialRoute: GroupsScreen.routeName,
        ),
      ),
    );
  }
}
