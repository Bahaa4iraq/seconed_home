import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:secondhome2/local_database/base_database.dart';
import 'package:sqflite/sqflite.dart';

import 'models/account.dart';

class SqlDatabase extends BaseDatabase {
  static Database? _productDb;
  static SqlDatabase? _sqlDatabase;

  SqlDatabase._createInstance();

  static final SqlDatabase db =
  SqlDatabase._createInstance();

  factory SqlDatabase() {
    _sqlDatabase ??= SqlDatabase._createInstance();
    return _sqlDatabase!;
  }

  Future<Database> get database async {
    _productDb ??= await initializeDatabase();
    return _productDb!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}secondhome.db';
    var myDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return myDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE accounts (_id INT ,token VARCHAR(255) NOT NULL,account_name VARCHAR(255) ,account_mobile VARCHAR(20) ,account_type VARCHAR(20) ,account_email VARCHAR(255) PRIMARY KEY,account_birthday DATE,account_address VARCHAR(255),is_kindergarten BOOLEAN)',
    );
  }

  @override
  Future deleteAccount(String email) async {
    final database = await this.database;
    await database.delete('accounts',where: 'account_email = ?', whereArgs: [email]);
  }

  @override
  Future<Account?> getAccount(String email) async {
    final database = await this.database;
    var result = await database.query('accounts',where:  'account_email = ?', whereArgs: [email]);
    return result.firstOrNull == null ? null : Account.fromMap(result.first);
  }

  @override
  Future<List<Account>> getAllAccount() async {
    final database = await this.database;
    var result = await database.query('accounts');
    return result.map((e) => Account.fromMap(e)).toList();
  }


  @override
  Future insertAccountAsMap(Map<String, dynamic> account)async {
    final user ={
      'token':account['token'],
      '_id': account['_id'],
      'account_name': account['account_name'],
      'account_mobile': account['account_mobile'],
      'account_type': account['account_type'],
      'account_email': account['account_email'],
      'account_birthday': account['account_birthday'],
      'account_address': account['account_address'],
      'is_kindergarten': account['is_kindergarten'] ? 1: 0,
    };
    final database = await this.database;
    var result = await database.query('accounts',where:  'account_email = ?', whereArgs: [user['account_email']]);
    if(result.isEmpty){
      await database.insert('accounts',user);
    }else{
      await database.update('accounts',user,where: 'account_email = ?', whereArgs: [user['account_email']]);
    }
  }
  @override
  Future insertAccount(Account account) async {
    final database = await this.database;
    var result = await database.query('accounts',where:  'account_email = ?', whereArgs: [account.accountEmail]);
    if(result.isEmpty){
      await database.insert('accounts',account.toMap());
    }else{
      await database.update('accounts',account.toMap(),where: 'account_email = ?', whereArgs: [account.accountEmail]);
    }
  }
  @override
  close() async {
    var db = await database;
    var result = db.close();
    return result;
  }
  
}