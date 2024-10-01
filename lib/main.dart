import 'package:flashcards/config/themes/custom_theme_colors.dart';
import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';
import 'package:flashcards/presentation/screens/new_flashcard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'data/datasources/sqlite_local_datasource.dart';
import 'presentation/screens/edit_flashcard_screen.dart';
import 'presentation/screens/groups_screen.dart';
import 'presentation/screens/new_group_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //Para asegurar que solo se ve verticalmente
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.system;
    final ThemeData theme = ThemeData();

    final lightTheme = theme.copyWith(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xffFAFAFA),
        // theme.colorScheme.copyWith(
        //     primary: Colors.black,
        //     secondary: Colors.black,
        //     //onPrimary: Colors.black
        // ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black
        ),
        inputDecorationTheme:  InputDecorationTheme(
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
              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 28),
              textStyle: const TextStyle(fontSize: 14),
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            )
        ),
        extensions: <ThemeExtension<dynamic>>[
          const CustomThemeColors(
              playButtonBackground: Colors.white,
              flashCardListItemBackground: Colors.white,
              flashCardListItemBorderColor: Colors.transparent,
              playButtonBoxShadows: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 6.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: Offset(
                    0.0, // Move to right 10  horizontally
                    2.0, // Move to bottom 10 Vertically
                  ),
                )
              ]
          )
        ]
    );

    final darkTheme = ThemeData.dark().copyWith(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xff222222),
        onPrimary: Colors.white,
        secondary: Colors.white,
        onSecondary: Color(0xff222222),
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Color(0xff222222),
      ),
      extensions: <ThemeExtension<dynamic>>[
        const CustomThemeColors(
          playButtonBackground: Color(0xff444444),
          flashCardListItemBackground: Colors.black,
          flashCardListItemBorderColor: Colors.grey,
          playButtonBoxShadows:[]
        )
      ]
    );

    return RepositoryProvider(
      create: (context) => SQLiteLocalDatasource(),
      child: BlocProvider(
        create: (context) => GroupsCubit(context.read<SQLiteLocalDatasource>()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Simple flashcards',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('es', ''), // Spanish, no country code
          ],
          routes: {
            GroupsScreen.routeName: (context) => const GroupsScreen(),
            NewGroupScreen.routeName: (context) => const NewGroupScreen(),
            NewFlashcardScreen.routeName: (context) => const NewFlashcardScreen(),
            EditFlashcardScreen.routeName: (context) => const EditFlashcardScreen(),
          },
          initialRoute: GroupsScreen.routeName,
        ),
      ),
    );
  }
}
