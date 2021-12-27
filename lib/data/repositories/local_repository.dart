import 'package:flashcards/domain/entities/group.dart';

abstract class LocalRepository {
  Future<List<Group>> getGroups();

  Future<void> insertGroup(Group group);

  Future<void> updateGroup(Group group);

  Future<void> deleteGroup(int groupId);
}