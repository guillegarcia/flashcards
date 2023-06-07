import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/design_config.dart';
import '../../data/datasources/sqlite_local_datasource.dart';
import '../../domain/entities/flash_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/group/group_cubit.dart';
import '../bloc/import_from_csv/import_from_csv_cubit.dart';
import '../widgets/text_and_button_full_page_widget.dart';

class ImportFromCSVScreen extends StatefulWidget {
  final GroupCubit groupCubit;

  const ImportFromCSVScreen({required this.groupCubit, Key? key}) : super(key: key);

  @override
  State<ImportFromCSVScreen> createState() => _ImportFromCSVScreenState();
}

class _ImportFromCSVScreenState extends State<ImportFromCSVScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.importFromCSV),
      ),
      body: Container(
        padding: DesignConfig.screenPadding,
        child: BlocProvider(
          create: (context) => ImportFromCsvCubit(groupBloc: widget.groupCubit,localRepository: context.read<SQLiteLocalDatasource>()),
          child: BlocBuilder<ImportFromCsvCubit, ImportFromCsvState>(
            builder: (context, state) {
              if (state is ImportFromCsvInitialState) {
                return const ImportFromCsvInitialStateContent();
              }
              if (state is ImportFromCsvInProgressState) {
                return const ImportFromCsvInProgressStateContent();
              }
              if (state is ImportFromCsvSuccessState) {
                return ImportFromCsvSuccessStateContent(state);
              }
              return const ImportFromCsvErrorStateContent();
            },
          ),
        ),
      ),
    );
  }
}

class ImportFromCsvInitialStateContent extends StatelessWidget {
  const ImportFromCsvInitialStateContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextAndButtonFullPageWidget(
      text: AppLocalizations.of(context)!.importFromCsvInitialMessage,
      buttonText: AppLocalizations.of(context)!.importFromCSV.toUpperCase(),
      buttonOnPressed: (){
        context.read<ImportFromCsvCubit>().import();
      }
    );
  }
}

class ImportFromCsvInProgressStateContent extends StatelessWidget {
  const ImportFromCsvInProgressStateContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ImportFromCsvSuccessStateContent extends StatelessWidget {
  ImportFromCsvSuccessState state;
  ImportFromCsvSuccessStateContent(this.state,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextAndButtonFullPageWidget(
        text: 'VOLVER',//TODO: TRADUCIR y mejorar
        buttonText: AppLocalizations.of(context)!.share.toUpperCase(),
        buttonOnPressed: (){
          //TODO: volver a grupo
          print('volver');
        }
    );
  }
}

class ImportFromCsvErrorStateContent extends StatelessWidget {
  const ImportFromCsvErrorStateContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('ERROR');
  }
}

