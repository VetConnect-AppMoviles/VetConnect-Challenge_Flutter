import 'package:py_integrador_pokemon/models/Pokemon.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'pokemons.db'),
          onCreate: (db, version) {
            db.execute(
                'CREATE TABLE pokemons(id INTEGER PRIMARY KEY, name TEXT)');
          }, version: version);
    }
    return db!;
  }

  Future<int> insertPokemon(Pokemon pokemon) async {
    int id = await db!.insert('pokemons', pokemon.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> deletePokemon(Pokemon pokemon) async {
    int result =
    await db!.delete('pokemons', where: 'id = ?', whereArgs: [pokemon.id]);
    return result;
  }

  Future<bool> isFavorite(Pokemon pokemon) async {
    final List<Map<String, dynamic>> maps =
    await db!.query('pokemons', where: 'id = ?', whereArgs: [pokemon.id]);
    return maps.length > 0;
  }
}