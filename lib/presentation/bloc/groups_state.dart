part of 'groups_bloc.dart';

abstract class GroupsState extends Equatable {
  const GroupsState();
}

class GroupsInitial extends GroupsState {
  @override
  List<Object> get props => [];
}
