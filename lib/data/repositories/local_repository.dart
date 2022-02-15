import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/domain/entities/group.dart';

abstract class LocalRepository {
  Future<List<Group>> getGroups();

  Future<int> insertGroup(Group group);

  Future<void> updateGroup(Group group);

  Future<void> deleteGroup(int groupId);

  Future<List<Flashcard>> getFlashcardsByGroup(int groupId);

  Future<List<Flashcard>> getFlashcardsForReviewByGroup(int groupId);

  Future<int> insertFlashcard(Flashcard flashcard,int groupId);

  Future<void> updateFlashcard(Flashcard flashcard);

  Future<void> deleteFlashcard(int flashcardId);

  Future<void> deleteFlashcardsByGroup(int groupId);

  Future<void> markForReview(int flashcardId);

  Future<void> removeFromReview(int flashcardId);

}