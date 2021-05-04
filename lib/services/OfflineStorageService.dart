import 'package:restaurant_app2/models/Restaurant/Restaurant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

class OfflineStorageService extends GetxService{
  Future<Database> _database;
  static final String tableName = 'favRestaurant';
  static final String scheduleTableName = 'isScheduledTable';
  final String createTable = 'CREATE TABLE $tableName(id TEXT PRIMARY KEY, name TEXT, description TEXT, pictureId TEXT, city TEXT, rating REAL)';
  final String createSchedulTable ='CREATE TABLE $scheduleTableName(id INTEGER PRIMARY KEY, scheduled INTEGER)';
  final String getCount = 'SELECT COUNT(*) FROM $tableName';

  @override
  void onInit() async {
    ///init database
    try{
      _database = openDatabase(
        join(await getDatabasesPath(), "userprefs.db"),
        onCreate: (db, ver) async {
          var batch = db.batch();
          batch.execute(createTable);
          batch.execute(createSchedulTable);
          return await batch.commit();
        },
        version: 1,
      );
    }catch(e, st){
      print(st);
      print(e);
    }

    super.onInit();
  }

  Future<bool> isScheduled() async{
    bool isScheduled = false;
    
    try{
      final List<Map<String,dynamic>> list = 
                          await _database
                          .then((db) async => await db.query(scheduleTableName,));
      if(list.length > 0){
        var scheduled = list[0];
        isScheduled = scheduled['scheduled'] == 1 ? true : false;
      }
    }catch(e, st){
      print(st);
      print(e);
    }

    return isScheduled;
  }

  Future<void> setSchedule({bool schedule = true}) async {
    final Database db = await _database;
    await db.insert(
      scheduleTableName,
      {
        'id': 1,
        'scheduled': schedule ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Restaurant>> getFavList() async {
    List<Restaurant> favLists;

    final Database db = await _database;
    final List<Map<String,dynamic>> list = await db.query(tableName);
    
    favLists = List.generate(list.length, (i) {
      return Restaurant.fromMap(list[i]);
    });
    
    return favLists;
  }

  Future<bool> insertFav(Restaurant restaurant) async {
    bool res = true;

    final Database db = await _database;
    
    await db.insert(
      tableName,
      restaurant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return res;
  }

  Future<bool> deleteFav(String id) async {
    bool res = true;

    final Database db = await _database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return res;
  }

  Future<bool> isFav(String id) async {
    bool isfav = false;
    
    final Database db = await _database;
    final List<Map<String,dynamic>> list = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if(list.length > 0) isfav = true;

    return isfav;
  }

}
