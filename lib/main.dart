import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';
import 'package:flashcards/presentation/screens/new_flashcard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'data/datasources/sqlite_local_datasource.dart';
import 'presentation/screens/edit_flashcard_screen.dart';
import 'presentation/screens/group_screen.dart';
import 'presentation/screens/groups_screen.dart';
import 'presentation/screens/new_group_screen.dart';
import 'presentation/screens/sample_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SQLiteLocalDatasource(),
      child: BlocProvider(
        create: (context) => GroupsCubit(context.read<SQLiteLocalDatasource>()),
        child: MaterialApp(
          title: 'Simple flashcards',
          theme: ThemeData(
            primarySwatch: Colors.green,
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
          },
          initialRoute: GroupsScreen.routeName,
        ),
      ),
    );
  }
}
