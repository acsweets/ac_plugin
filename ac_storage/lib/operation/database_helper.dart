import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

///数据库需要的功能 创建数据库 建表  打开数据库  关闭数据库 增删改查
/// 给一个数据库名字 完成创建的功能

//单例
class DatabaseHelper {
  // 私有的构造函数
  DatabaseHelper._privateConstructor();

  // 静态私有实例
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  // 工厂构造函数返回同一个实例
  factory DatabaseHelper() {
    return _instance;
  }

  // 数据库名称，私有变量
  String? _databaseName;

  // 数据库实例
  static Database? _database;

  /// 初始化数据库名称，仅能调用一次
  void init({required String databaseName}) {
    if (_databaseName == null) {
      _databaseName = databaseName;
    } else {
      throw Exception("DatabaseHelper已经初始化过了");
    }
  }

  // 获取数据库实例
  Future<Database> get database async {
    if (_database != null) return _database!;
    if (_databaseName == null) {
      throw Exception("DatabaseHelper未初始化，请先调用init方法");
    }
    _database = await _initDatabase();
    return _database!;
  }

  // 初始化数据库
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), '$_databaseName.db');
    return await openDatabase(
      path,
      version: 1,
      // onCreate: _createDb,
    );
  }

  // 思考怎么整合建表 枚举数据库类型 名字
  Future<void> createTable(String table) async {
    Database db = await database;
    await db.execute(table);
  }

  // 增 (Create)
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('users', row);
  }

  // 查 (Read)
  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await database;
    return await db.query('users');
  }

  Future<Map<String, dynamic>?> queryUser(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  // 改 (Update)
  Future<int> updateUser(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update(
      'users',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 删 (Delete)
  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 高级查询示例
  Future<List<Map<String, dynamic>>> queryUsersByAgeRange(
      int minAge, int maxAge) async {
    Database db = await database;
    return await db.query(
      'users',
      where: 'age >= ? AND age <= ?',
      whereArgs: [minAge, maxAge],
      orderBy: 'age ASC',
    );
  }

  // 批量插入示例
  Future<void> insertMultipleUsers(List<Map<String, dynamic>> users) async {
    Database db = await database;
    Batch batch = db.batch();
    for (var user in users) {
      batch.insert('users', user);
    }
    await batch.commit(noResult: true);
  }
}

///final dbHelper = DatabaseHelper();
//
// // 插入用户
// int userId = await dbHelper.insertUser({
//   'name': 'John Doe',
//   'email': 'john@example.com',
//   'age': 30
// });
//
// // 查询用户
// Map<String, dynamic>? user = await dbHelper.queryUser(userId);
// print(user);
//
// // 更新用户
// await dbHelper.updateUser({
//   'id': userId,
//   'name': 'John Updated',
//   'age': 31
// });
//
// // 删除用户
// await dbHelper.deleteUser(userId);
//
// // 高级查询
// List<Map<String, dynamic>> usersInAgeRange = await dbHelper.queryUsersByAgeRange(25, 35);
// print(usersInAgeRange);
//
// // 批量插入
// await dbHelper.insertMultipleUsers([
//   {'name': 'Alice', 'email': 'alice@example.com', 'age': 28},
//   {'name': 'Bob', 'email': 'bob@example.com', 'age': 35}
// ]);
