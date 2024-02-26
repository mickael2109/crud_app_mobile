import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'package:p5_app_with_sqlite/model/item.dart';
import 'dart:async';

class SQLHelper{
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      title TEXT,
      description TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbestech.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
        print("...creating a table..."); 
      }
    );
  }

  static Future<int> createItem(String title, String? description) async {
    final db = await SQLHelper.db();
    final data = {'title':title, 'description':description};
    final id = await db.insert('items', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String title, String? description) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'description':description,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print("Something went wrong when deleting an item : $err");
    }
  }
}
// class DatabaseClient {

//   late Database _database;

//   // Fonction d'initialisation de la base de données
//   Future<void> initDatabase() async {
//     _database = await create();
//   }

//   // Méthode pour obtenir la base de données
//   Future<Database> get database async {
//     if (_database.isOpen) {
//       return _database;
//     } else {
//       // Si la base de données n'est pas ouverte, initialiser
//       await initDatabase();
//       return _database;
//     }
//   }

//   Future create()async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     String databaseDirectory = join(directory.path, 'database.db');
//     var bdd = await openDatabase(databaseDirectory, version: 1, onCreate: _onCreate);
//     return bdd;  
//   }

//   Future _onCreate(Database db, int version) async {
//     await db.execute(
//       '''
//         CREATE TABLE item (id INTEGER PRIMARY KEY, nom TEXT NOT NULL)
//       ''');
//   }


//   // AJOUT DES DONNEES
//   Future<Item> ajoutItem(Item item) async {
//     Database maDatabase = await database;
//     item.id = await maDatabase.insert('item', item.toMap());
//     print('item.id : ${item.id}');
//     return item;
//   }


//   // LECTURE DES DONNES
//   Future<List<Item>> allItem() async {
//     Database maDatabase = await database;
//     List<Map<String,dynamic>> resultat = await maDatabase.rawQuery('SELECT * FROM item');
//     List<Item> items = [];
//     resultat.forEach((map) { 
//       Item item = new Item();
//       item.fromMap(map);
//       items.add(item);
//     });

//     return items;
//   }

// }