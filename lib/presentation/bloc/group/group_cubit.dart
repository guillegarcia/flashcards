import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/domain/entities/group.dart';
import 'package:flutter/cupertino.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final LocalRepository _localRepository;
  final Group group;

  GroupCubit(this._localRepository,{required Group this.group}) : super(LoadFlashcardsInProgressState()){
    loadFlashcards(group.id!);
  }

  void loadFlashcards(int groupId) async {
    try {
      emit(LoadFlashcardsInProgressState());
      final groups = await _localRepository.getFlashcardsByGroup(groupId);
      emit(LoadFlashcardsSuccessState(groups));
    } catch (e) {
      emit(LoadFlashcardsErrorState());
    }
  }
}
