// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:p5_app_with_sqlite/model/article.dart';
import 'package:sqflite/sqflite.dart' as sql;
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

    await database.execute("""CREATE TABLE article(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nom TEXT NOT NULL,
        item INTEGER,
        prix TEXT,
        magasin TEXT,
        image TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbestech.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print("... creating table ...");
        await createTables(database);
      }
    );
  }
  //   // AJOUT DES DONNEES
//   Future<Item> ajoutItem(Item item) async {
//     Database maDatabase = await database;
//     item.id = await maDatabase.insert('item', item.toMap());
//     print('item.id : ${item.id}');
//     return item;
//   }

  // static Future<int> createItem(String title, String? description) async {
  //   final db = await SQLHelper.db();
  //   final data = {'title':title, 'description':description};
  //   final id = await db.insert('items', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  //   return id;
  // }

 /* AJOUTER DES DONNES */
    // ITEM
  static Future<Item> createItem(Item item) async {
    final db = await SQLHelper.db();
    final data = item.toMap();
    item.id = await db.insert('items', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print("item.id : ${item.id}");
    return item;
  }

  // ARTICLE
  static Future<Article> createArticle(Article article) async {
    final db = await SQLHelper.db();
    final data = article.toMap();
    article.id = await db.insert('article', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print("article.id : ${article.id}");
    return article;
  }




  /* RECUPERER TOUT LES DONNES */
    // ITEM
  static Future<List<Item>> getAlls() async {
    final db = await SQLHelper.db();
    List<Map<String,dynamic>> resultat = await db.query('items', orderBy: "id");
    List<Item> items = [];
    resultat.forEach((map) { 
      Item item = new Item();
      item.fromMap(map);
      items.add(item);
    });
    return items;
  }

    // ARTICLE
  static Future<List<Article>> allArticles(int item) async {
    final db = await SQLHelper.db();
    List<Map<String,dynamic>> resultat = await db.query('article', where: 'item = ?', whereArgs: [item]);

    List<Article> articles = [];

    resultat.forEach((map) { 
      Article article = new Article();
      article.fromMap(map);
      articles.add(article);
    });
    return articles;
  }

  // static Future<List<Map<String, dynamic>>> getItems() async {
  //   final db = await SQLHelper.db();
  //   return db.query('items', orderBy: "id");
  // }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // static Future<int> updateItem(int id, String title, String? description) async {
  //   final db = await SQLHelper.db();
  //   final data = {
  //     'title': title,
  //     'description':description,
  //     'createdAt': DateTime.now().toString()
  //   };

  //   final result = await db.update('items', data, where: "id = ?", whereArgs: [id]);
  //   return result;
  // }

  static Future<Item> updateItem(int id, Item item) async {
    final db = await SQLHelper.db();
    final data = item.toMap();
    item.id = await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return item;
  }


 /* SUPPRIMMER DES DONNES */
  static Future<void> deleteItem(int id, String table) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('article', where: 'item = ?', whereArgs: [id]);
      await db.delete(table, where: "id = ?", whereArgs: [id]);
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