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
      print('updateGroup cubit ${group.name}');
      emit(UpdateInProgressState());
      await _localRepository.updateGroup(group);
      if(groupsBloc.state is LoadSuccessState){
        groupsBloc.loadGroups();//.addCreatedGroup(group);
      }
      emit(UpdateSuccessState());
    } catch (e) {
      emit(UpdateErrorState());
    }

  }
}
