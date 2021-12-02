import 'package:flutter/cupertino.dart';
import 'package:maker_note/composant.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class NoteDatabase {
  NoteDatabase._privateConstructor();

  static final NoteDatabase instance = NoteDatabase._privateConstructor();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'note.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE Composant(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, titre TEXT, note TEXT, isFavorite INTEGER, isVocal INTEGER)');
      },
      version: 1,
    );
  }

  void insertNote(String titre, String note, bool isFavorite, bool isVocal) async {
    final Database? db = await database;
    var valeur = {'titre': titre, 'note': note, 'isFavorite': isFavorite, 'isVocal': isVocal};
    await db!.insert(
      'Composant',
      valeur,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateNote(String titre, String note, Composant composant, bool isFavorite) async {
    final Database? db = await database;
    var valeur = {'titre': titre, 'note': note, 'isFavorite': isFavorite};
    await db!.update('Composant', valeur,
        where: 'id = ?', whereArgs: [composant.id]);
  }

  void deleteNote(int id) async {
    final Database? db = await database;
    await db!.delete('Composant', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Composant>> composants() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT * FROM composant ORDER BY id DESC');
    List<Composant> composants = List.generate(maps.length, (i) {
      return Composant.fromMap(maps[i]);
    });
    if (composants.isEmpty) {}
    return composants;
  }

  Future<List<Composant>> favoris() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM composant WHERE isFavorite = 1 ORDER BY id DESC');
    List<Composant> composants = List.generate(maps.length, (i) {
      return Composant.fromMap(maps[i]);
    });
    if (composants.isEmpty) {}
    return composants;
  }

  Future<List<Composant>> recherche(String nom) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM composant WHERE titre LIKE ? ORDER BY id DESC', ['%$nom%']);
    List<Composant> composants = List.generate(maps.length, (i) {
      return Composant.fromMap(maps[i]);
    });
    if (composants.isEmpty) {}
    return composants;
  }
  Future<List<Composant>> recherchefavoris(String nom) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'SELECT * FROM composant WHERE titre LIKE ? AND isFavorite = 1 ORDER BY id DESC', ['%$nom%']);
    List<Composant> composants = List.generate(maps.length, (i) {
      return Composant.fromMap(maps[i]);
    });
    if (composants.isEmpty) {}
    return composants;
  }
}
