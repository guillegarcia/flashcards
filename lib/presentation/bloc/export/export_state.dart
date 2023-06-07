part of 'export_cubit.dart';

@immutable
abstract class ExportState {}

class ExportInitialState extends ExportState {}
class ExportInProgressState extends ExportState {}
class ExportSuccessState extends ExportState {
  final String csvPath;

  ExportSuccessState({required this.csvPath});
}
class ExportErrorState extends ExportState {}
