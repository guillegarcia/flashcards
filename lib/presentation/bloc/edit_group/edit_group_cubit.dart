import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/group.dart';
import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';

part 'edit_group_state.dart';

class EditGroupCubit extends Cubit<EditGroupState> {
  final GroupsCubit groupsBloc;
  final LocalRepository _localRepository;

  EditGroupCubit(this._localRepository, {required this.groupsBloc}) : super(EditGroupInitial());

  void updateGroup(Group group) async{
    try{
      emit(UpdateInProgressState());
      await _localRepository.updateGroup(group);
      groupsBloc.loadGroups();
      emit(UpdateSuccessState());
    } catch (e) {
      emit(UpdateErrorState());
    }
  }

  void deleteGroup(Group group) async{
    try{
      emit(DeleteGroupInProgressState());
      await _localRepository.deleteFlashcardsByGroup(group.id!);
      await _localRepository.deleteGroup(group.id!);
      if(groupsBloc.state is LoadSuccessState){
        groupsBloc.loadGroups();
      }
      emit(DeleteGroupSuccessState());
    } catch (e) {
      emit(DeleteGroupErrorState());
    }
  }
}
