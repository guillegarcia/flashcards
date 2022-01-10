part of 'groups_cubit.dart';

abstract class GroupsState extends Equatable {
  const GroupsState();
}

class LoadingState extends GroupsState {
  @override
  List<Object> get props => [];
}

class LoadedState extends GroupsState {
  LoadedState(this.groups);

  List<Group> groups;

  @override
  List<Object> get props => [groups];
}

class ErrorState extends GroupsState {
  @override
  List<Object> get props => [];
}