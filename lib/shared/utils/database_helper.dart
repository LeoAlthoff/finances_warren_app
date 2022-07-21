import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbVersion = 1;
  static const _operationTable = 'operation';
  static const _categoryTable = 'category';
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper();

  DatabaseHelper() {
    _initiateDatabase();
  }

  void _initiateDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = '${databasesPath}warrFinances.db';
    _database = await openDatabase(
      onConfigure: _onConfigure,
      path,
      version: _dbVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE $_categoryTable
        (id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color TEXT NOT NULL,
        icon TEXT NOT NULL)''');
        await db.execute('''CREATE TABLE $_operationTable
        (id INTEGER PRIMARY KEY AUTOINCREMENT,
        value NUM NOT NULL,
        name TEXT NOT NULL,
        entry INTERGER NOT NULL,
        date TEXT NO NULL,
        categoryId INTERGER,
        FOREIGN KEY(categoryId) REFERENCES Category(id)
         )''');
        await db.rawInsert(
          '''INSERT INTO Category(name, color, icon) 
        VALUES('Salário', 'Color(0xff000000)', 'Icons.attach_money'),
        ('Alimentação', 'Color(0xfff50707)', 'Icons.restaurant'),
        ('Compras', 'Color(0xfff0f507)', 'Icons.shopping_bag'),
        ('Aluguel', 'Color(0xff072cf5)', 'Icons.house'),
        ('Telefone', 'Color(0xff09ab10)', 'Icons.phone'),
        ('Contas', 'Color(0xff920a79)', 'Icons.request_page_rounded')
        ''',
        );
        await db.rawInsert('''
        INSERT INTO Operation (value, name, entry, date, categoryId)
        VALUES(2500, 'Warren Tecnologia', 1, '01/07/2022', 1),
        (2500, 'Ifood', 0, '22/06/2022', 2),
        (620, 'Angeloni', 0, '18/06/2022', 3),
        (15500, 'Professor Ailton', 1, '01/07/2022', 1)   
        ''');
      },
    );
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  void insertCategory(String name, String color, String icon) async {
    await _database!.rawInsert(
      'INSERT INTO Category(name, color, icon) VALUES(?, ?, ?)',
      [name, color, icon],
    );
  }

  void insertOperation(
      double value, String name, int entry, String date, int categoryId) async {
    await _database!.rawInsert(
      'INSERT INTO operation(value, name, entry, date, categoryId) VALUES(?, ?, ?, ?, ?)',
      [value, name, entry, date, categoryId],
    );
  }

  Future<List<Map<String, dynamic>>> queryCategory() async {
    return await _database!.rawQuery('SELECT * FROM Category');
  }

  Future<Map<int, double>> queryOperation(String monthYear) async {
    List<Map<String, dynamic>> list = await _database!.query(
      'Operation',
      where: 'entry = ? AND date LIKE ? ',
      whereArgs: [0, '%$monthYear%'],
      orderBy: "categoryId",
    );
    Set differentIds = {};

    for (Map<String, dynamic> item in list) {
      differentIds.add(item['categoryId']);
    }

    Map<int, double> sumId = {};

    for (int id in differentIds) {
      sumId.addAll({id: 0});
      for (Map<String, dynamic> operation in list) {
        double newSum = sumId[id]!;
        if (operation['categoryId'] == id) {
          num adding = operation['value'] as num;
          newSum += adding;
          sumId[id] = newSum;
        }
      }
    }
    return sumId;
    print(sumId);
  }

  Future<int> selectCategory(String categoryName) async {
    List<Map> list = await _database!.rawQuery(
      'SELECT id FROM Category WHERE Name= ?',
      [categoryName],
    );
    return list[0]['id'];
  }

  Future<String> getCategory(int id) async {
    List<Map<String, dynamic>> list = await _database!.rawQuery(
      'SELECT Name FROM Category WHERE id= ?',
      [id],
    );
    return list[0]['Name'];
  }

  Future<List<Map<String, dynamic>>> selectOperation() async {
    List<Map<String, dynamic>> list =
        await _database!.rawQuery('SELECT * FROM operation');
    print(list);

    return list;
  }

  void deleteCategory(int id) async {
    await _database!.rawDelete(
      'DELETE FROM Category WHERE id = ?',
      ['$id'],
    );
  }

  void deleteOperation(String name) async {
    await _database!.rawDelete(
      'DELETE FROM operation WHERE name = ?',
      [name],
    );
  }

  void deleteAllData() async {
    var databasesPath = await getDatabasesPath();
    String path = '${databasesPath}warrFinances.db';
    await deleteDatabase(path);
  }

  void closeDatabase() async {
    await _database!.close();
  }
}
