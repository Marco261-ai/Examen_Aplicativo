import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'estudiantes.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Crear tabla
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE estudiantes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        edad TEXT,
        fecha TEXT,
        pais TEXT,
        ciudad TEXT,
        cuotaInicial REAL,
        cuotaMensual REAL
      )
    ''');
  }

  // Insertar estudiante
  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert('estudiantes', student.toMap());
  }

  // Obtener todos los estudiantes
  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('estudiantes');
    return result.map((map) => Student.fromMap(map)).toList();
  }

  // (Opcional) Actualizar estudiante
  Future<int> updateStudent(Student student) async {
    final db = await database;
    return await db.update(
      'estudiantes',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // (Opcional) Eliminar estudiante
  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete('estudiantes', where: 'id = ?', whereArgs: [id]);
  }
}
