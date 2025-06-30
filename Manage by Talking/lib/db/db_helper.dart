import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';
import "package:skd1/models/task.dart";

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = join(await getDatabasesPath(), 'tasks.db');
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          print("Yeni veritabanı oluşturuluyor...");
          await db.execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER)"
          );
        },
      );
    } catch (e) {
      print("Veritabanı başlatılırken hata: $e");
    }
  }

  static Future<int> insert(Task? task) async {
    if (task == null) return 0;
    await initDb();
    task.title = task.title?.trim();
    return await _db?.insert(_tableName, task.toJson()) ?? 0;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    await initDb();
    return await _db!.query(_tableName);
  }

  static Future<int> delete(Task task) async {
    await initDb();
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> markTaskCompletedById(int id) async {
    await initDb();
    return await _db!.rawUpdate('UPDATE $_tableName SET isCompleted = 1 WHERE id = ?', [id]);
  }

  static Future<int> deleteByTitle(String title) async {
    await initDb();
    return await _db!.delete(_tableName, where: 'TRIM(LOWER(title)) = ?', whereArgs: [title.trim().toLowerCase()]);
  }
  
  static Future<int> deleteByTitleAndDate(String title, String date) async {
    await initDb();
    return await _db!.delete(_tableName, where: 'TRIM(LOWER(title)) = ? AND date = ?', whereArgs: [title.trim().toLowerCase(), date]);
  }

  static Future<int> completeByTitle(String title) async {
    await initDb();
    return await _db!.update(_tableName, {'isCompleted': 1}, where: 'TRIM(LOWER(title)) = ?', whereArgs: [title.trim().toLowerCase()]);
  }
  
  static Future<int> completeByTitleAndDate(String title, String date) async {
    await initDb();
    return await _db!.update(_tableName, {'isCompleted': 1}, where: 'TRIM(LOWER(title)) = ? AND date = ?', whereArgs: [title.trim().toLowerCase(), date]);
  }

  static Future<int> deleteAllCompleted() async {
    await initDb();
    return await _db!.delete(_tableName, where: 'isCompleted = ?', whereArgs: [1]);
  }

  // =============================================================================
  // === GÜNCELLEME FONKSİYONU - BASİTLEŞTİRİLMİŞ HALİ ========================
  // =============================================================================
  static Future<int> updateTaskByTitle({
    required String oldTitle,
    required Map<String, dynamic> dataToUpdate, // Artık doğrudan bir Map alıyor
  }) async {
    print("DBHelper: Görev güncelleme çağrıldı -> Eski Başlık: $oldTitle");
    await initDb();
    
    if (dataToUpdate.isEmpty) {
      print("DBHelper: Güncellenecek yeni bir veri bulunamadı.");
      return 0;
    }
    
    print("DBHelper: Güncellenecek Veri: $dataToUpdate");

    return await _db!.update(
      _tableName,
      dataToUpdate,
      where: 'TRIM(LOWER(title)) = ?',
      whereArgs: [oldTitle.trim().toLowerCase()],
    );
  }
}