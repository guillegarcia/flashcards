part of 'edit_group_cubit.dart';

abstract class EditGroupState extends Equatable {
  const EditGroupState();
}

class EditGroupInitial extends EditGroupState {
  @override
  List<Object> get props => [];
}

class UpdateInProgressState extends EditGroupState {
  @override
  List<Object> get props => [];
}

class UpdateSuccessState extends EditGroupState {
  @override
  List<Object> get props => [];
}

class UpdateErrorState extends EditGroupState {
  @override
  List<Object> get props => [];
}

class DeleteGroupInProgressState extends EditGroupState {
  @override
  List<Object> get props => [];
}

class DeleteGroupSuccessState extends EditGroupState {
  @override
  List<Object> get props => [];
}

class DeleteGroupErrorState extends EditGroupState {
  @override
  List<Object> get props => [];
}