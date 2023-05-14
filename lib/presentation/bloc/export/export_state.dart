part of 'export_cubit.dart';

@immutable
abstract class ExportState {}

class ExportInProgressState extends ExportState {}
class ExportSuccessState extends ExportState {}
class ExportErrorState extends ExportState {}
