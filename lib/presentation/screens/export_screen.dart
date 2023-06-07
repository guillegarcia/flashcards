import 'package:flashcards/presentation/bloc/export/export_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/design_config.dart';
import '../../domain/entities/flash_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/text_and_button_full_page_widget.dart';

class ExportScreen extends StatefulWidget {
  final List<Flashcard> flashcards;

  ExportScreen({required this.flashcards, Key? key}) : super(key: key);

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.exportFlashcards),
      ),
      body: Container(
        padding: DesignConfig.screenPadding,
        child: BlocProvider(
          create: (context) => ExportCubit(flashcards:widget.flashcards),
          child: BlocBuilder<ExportCubit, ExportState>(
            builder: (context, state) {
              if (state is ExportInitialState) {
                return const ExportInicialStateContent();
              }
              if (state is ExportInProgressState) {
                return const ExportInProgressStateContent();
              }
              if (state is ExportSuccessState) {
                return ExportSuccessStateContent(state);
              }
              return const ExportErrorStateContent();
            },
          ),
        ),
      ),
    );
  }
}

class ExportInicialStateContent extends StatelessWidget {
  const ExportInicialStateContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextAndButtonFullPageWidget(
      text: AppLocalizations.of(context)!.exportInitialMessage,
      buttonText: AppLocalizations.of(context)!.exportFlashcards.toUpperCase(),
      buttonOnPressed: (){
        context.read<ExportCubit>().exportFlashcards();
      }
    );
  }
}

class ExportInProgressStateContent extends StatelessWidget {
  const ExportInProgressStateContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ExportSuccessStateContent extends StatelessWidget {
  ExportSuccessState state;
  ExportSuccessStateContent(this.state,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextAndButtonFullPageWidget(
      text: AppLocalizations.of(context)!.exportSuccessMessage,
      buttonText: AppLocalizations.of(context)!.share.toUpperCase(),
      buttonOnPressed: (){
        context.read<ExportCubit>().shareCsv(state.csvPath);
      }
    );
  }
}

class ExportErrorStateContent extends StatelessWidget {
  const ExportErrorStateContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('ERROR');
  }
}