import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/flash_card.dart';
import 'package:flashcards/domain/entities/group.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class SQLiteLocalDatasource implements LocalRepository{

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "flashcards.db");
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: _createTables);
  }

  void _createTables(Database database, int version) async {
    await database.execute("CREATE TABLE groups ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "name TEXT,"
        "description TEXT"
        ")");

    await database.execute("CREATE TABLE flashcards ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "group_id INTEGER,"
        "question TEXT NOT NULL,"
        "answer TEXT NOT NULL"
        ")");

    await database.execute("CREATE TABLE review ("
        "flashcard_id INTEGER PRIMARY KEY NOT NULL"
        ")");
  }

  @override
  Future<void> deleteGroup(int groupId) async {
    final db = await database;
    await db.delete("groups",where: 'id=?',whereArgs: [groupId]);
    await db.delete("flashcards",where: 'group_id=?',whereArgs: [groupId]);
  }

  @override
  Future<List<Group>> getGroups() async {
    final db = await database;
    List<Group> groups = [];
    var result = await db.query("groups", columns: ['id','name','description']);
    for(final row in result){
      groups.add(_groupFromMap(row));
    }
    return groups;
  }

  @override
  Future<int> insertGroup(Group group) async{
    final db = await database;
    return await db.insert("groups", _groupToMap(group));
  }

  @override
  Future<void> updateGroup(Group group) async {
    final db = await database;
    Map<String,dynamic> values = _groupToMap(group);
    await db.update("groups",values,where: 'id=?',whereArgs: [group.id]);
  }

  @override
  Future<void> deleteFlashcard(int flashcardId) async {
    final db = await database;
    await db.delete("flashcards",where: 'id=?',whereArgs: [flashcardId]);
  }

  @override
  Future<List<Flashcard>> getFlashcardsByGroup(int groupId) async{
    final db = await database;
    List<Flashcard> flashcards = [];
    var result = await db.query("flashcards", columns: ['id','name','description'],where: 'group_id=?',whereArgs: [groupId]);
    for(final row in result){
      flashcards.add(_flashcardFromMap(row));
    }
    return flashcards;
  }

  @override
  Future<void> insertFlashcard(Flashcard flashcard) async {
    final db = await database;
    await db.insert("flashcards", _flashcardToMap(flashcard));
  }

  @override
  Future<void> updateFlashcard(Flashcard flashcard) async{
    final db = await database;
    Map<String,dynamic> values = _flashcardToMap(flashcard);
    await db.update("flashcard",values,where: 'id=?',whereArgs: [flashcard.id]);
  }

  Group _groupFromMap(Map<String, dynamic> map) {
    print('Grupo MAPA: $map');
    return Group(
      id: map['id'] ?? -1,
      name: map['name'] ?? '',
      description: map['description'] ?? ''
    );
  }

  Flashcard _flashcardFromMap(Map<String, dynamic> map) {
    return Flashcard(
        id: map['id'] ?? -1,
        question: map['question'] ?? '',
        answer: map['answer'] ?? ''
    );
  }

  Map<String, Object?> _groupToMap(Group group) {
    Map<String, dynamic> result = {
      "name": group.name,
      "description": group.description
    };
    return result;
  }

  Map<String, Object?> _flashcardToMap(Flashcard flashcard) {
    Map<String, dynamic> result = {
      "question": flashcard.question,
      "answer": flashcard.answer
    };
    return result;
  }
}