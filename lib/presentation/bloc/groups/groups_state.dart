part of 'groups_cubit.dart';

abstract class GroupsState extends Equatable {
  const GroupsState();
}

class LoadInProgressState extends GroupsState {
  @override
  List<Object> get props => [];
}

class LoadSuccessState extends GroupsState {
  LoadSuccessState(this.groups);

  List<Group> groups;

  @override
  List<Object> get props => [groups];
}

class LoadErrorState extends GroupsState {
  @override
  List<Object> get props => [];
}