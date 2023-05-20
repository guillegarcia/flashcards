import 'package:flashcards/presentation/bloc/export/export_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/flash_card.dart';

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
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => ExportCubit(flashcards:widget.flashcards),
        child: BlocBuilder<ExportCubit, ExportState>(
          builder: (context, state) {
            if (state is ExportInProgressState)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (state is ExportSuccessState)
              return Container(
                child: Column(
                  children: [
                    Text('Exportado!'),
                    Text('Path ${state.csvPath}'),
                    ElevatedButton(onPressed: (){
                        context.read<ExportCubit>().shareCsv(state.csvPath);
                      }, child: Text('Compartir')
                    )
                  ],
                ),
              );
            return Text('ERROR');
          },
        ),
      ),
    );
  }
}
