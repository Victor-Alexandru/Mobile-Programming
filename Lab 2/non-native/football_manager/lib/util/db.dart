import 'package:football_manager/model/teamItem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:football_manager/model/nodo_item.dart';

final String tableChamps = 'championships';
final String columnId = 'id';
final String columnTrophy = 'trophy';
final String columnTotalMatches = 'totalMatches';


final String tableTeams = 'teams';
final String columnTeamName = 'teamName';
final String columnPoints = 'points';
final String columnChampionshipId = 'championshipId';

class DbHelper {
  Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    var p = await getDatabasesPath();
    String path = p + "/management_bun3.db";
    _db = await open(path);
    return _db;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    dbClient.execute("delete * from $tableTeams where $columnChampionshipId = id");
    return await dbClient
        .delete(tableChamps, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteTeam(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableTeams, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(ChampionshipItem item) async {
    var dbClient = await db;
    return await dbClient.update(tableChamps, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
  }

  Future<int> updateTeam(TeamItem item) async {
    var dbClient = await db;
    return await dbClient.update(tableTeams, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
  }

  open(String path) async {
    var d = await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      await db.execute('''
        create table $tableChamps ( 
          $columnId integer primary key autoincrement, 
          $columnTrophy text,
          $columnTotalMatches text)''');

      await db.execute('''
        create table $tableTeams ( 
          $columnId integer primary key autoincrement, 
          $columnTeamName text,
          $columnChampionshipId integer,
          $columnPoints text)''');

    });
    return d;
  }

  Future<ChampionshipItem> insertC(ChampionshipItem item) async {
    var dbClient = await db;
    item.id = await dbClient.insert(tableChamps, item.toMap());
    return item;
  }

  Future<TeamItem> insertTeam(TeamItem item) async {
    var dbClient = await db;
    item.id = await dbClient.insert(tableTeams, item.toMap());
    return item;
  }

  Future<List> getItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableChamps");
    print("&&&&&&&&&&&&&&&&&&&&&&&");
    print(result.toList());
    print("&&&&&&&&&&&&&&&&&&&&&&&");
    return result.toList();
  }

  Future<List> getItemsTeams(int championshipId) async {


    var dbClient = await db;

    var result = await dbClient.rawQuery("SELECT * FROM $tableTeams WHERE  championshipId ="+championshipId.toString());
    print(result.toList());
    return result.toList();
  }
}
