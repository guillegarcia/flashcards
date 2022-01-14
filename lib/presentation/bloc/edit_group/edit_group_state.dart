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