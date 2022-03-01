import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/group.dart';
import 'package:flashcards/presentation/bloc/groups/groups_cubit.dart';

part 'new_group_state.dart';

class NewGroupCubit extends Cubit<NewGroupState> {
  final GroupsCubit groupsBloc;
  final LocalRepository _localRepository;

  NewGroupCubit(this._localRepository, {required GroupsCubit this.groupsBloc}) : super(NewGroupInitial());

  void createGroup(Group group) async{
    try{
      print('createGroup cubit ${group.name}, ${group.color}');
      emit(CreateInProgressState());
      group.id = await _localRepository.insertGroup(group);
      if(groupsBloc.state is LoadSuccessState){
        groupsBloc.loadGroups();//.addCreatedGroup(group);
      }
      emit(CreateSuccessState());
    } catch (e) {
      emit(CreateErrorState());
    }

  }
}
