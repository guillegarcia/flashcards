part of 'new_group_cubit.dart';

abstract class NewGroupState extends Equatable {
  const NewGroupState();
}

class NewGroupInitial extends NewGroupState {
  @override
  List<Object> get props => [];
}

class CreatingState extends NewGroupState {
  @override
  List<Object> get props => [];
}

class CreateSuccessState extends NewGroupState {
  @override
  List<Object> get props => [];
}

class CreateErrorState extends NewGroupState {
  @override
  List<Object> get props => [];
}
