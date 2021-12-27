import 'package:flashcards/data/repositories/local_repository.dart';
import 'package:flashcards/domain/entities/group.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteLocalDatasource implements LocalRepository{

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    /*Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "dafos.db");
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: _createTables);*/
  }

  void _createTables(Database database, int version) async {
    await database.execute("CREATE TABLE dafo ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "title TEXT,"
        "description TEXT"
        ")");

    await database.execute("CREATE TABLE dafo_element ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "dafo_id INTEGER,"
        "position INTEGER,"
        "text TEXT,"
        "type INTEGER"
        ")");
  }

  @override
  Future<void> deleteGroup(int groupId) {
    // TODO: implement deleteGroup
    throw UnimplementedError();
  }

  @override
  Future<List<Group>> getGroups() {
    // TODO: implement getGroups
    throw UnimplementedError();
  }

  @override
  Future<void> insertGroup(Group group) {
    // TODO: implement insertGroup
    throw UnimplementedError();
  }

  @override
  Future<void> updateGroup(Group group) {
    // TODO: implement updateGroup
    throw UnimplementedError();
  }

}