import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/group.dart';

part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit(this._localRepository) : super(LoadingState()){
    loadGroups();
  }

  final LocalRepository _localRepository;

  void loadGroups() async {
    try {
      emit(LoadingState());
      final groups = await _localRepository.getGroups();
      emit(LoadedState(groups));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
