import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skd1/db/db_helper.dart';
import 'package:skd1/models/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  // Sadece uygulama ilk açıldığında çağrılır.
  Future<void> getTasks() async {
    try {
      List<Map<String, dynamic>> tasks = await DBHelper.query();
      taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
      print('TaskController: Liste veritabanından ilk kez yüklendi.');
    } catch (e) {
      print('TaskController: getTasks hatası: $e');
    }
  }

  Future<int> addTask({Task? task}) async {
    if (task == null) return 0;
    final newId = await DBHelper.insert(task);
    if (newId > 0) {
      // getTasks() çağırmak yerine direkt listeye ekleyerek performansı artırıyoruz.
      taskList.add(task.copyWith(id: newId));
    }
    return newId;
  }

  Future<void> delete(Task task) async {
    await DBHelper.delete(task);
    taskList.remove(task);
  }

  Future<void> markTaskCompleted(int id) async {
    await DBHelper.markTaskCompletedById(id);
    var taskIndex = taskList.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      // getTasks() çağırmak yerine listedeki objeyi güncelliyoruz.
      taskList[taskIndex].isCompleted = 1;
      taskList.refresh();
    }
  }
  
  Future<void> deleteAllCompletedTasks() async {
    await DBHelper.deleteAllCompleted();
    taskList.removeWhere((task) => task.isCompleted == 1);
  }

  Future<void> deleteTaskByTitle(String title) async {
    await DBHelper.deleteByTitle(title);
    taskList.removeWhere((task) => task.title?.trim().toLowerCase() == title.trim().toLowerCase());
  }

  Future<void> deleteTaskByTitleAndDate(String title, String date) async {
    await DBHelper.deleteByTitleAndDate(title, date);
    taskList.removeWhere((task) => 
        task.title?.trim().toLowerCase() == title.trim().toLowerCase() && 
        task.date == date);
  }

  Future<void> completeTaskByTitle(String title) async {
    await DBHelper.completeByTitle(title);
    var taskIndex = taskList.indexWhere((task) => task.title?.trim().toLowerCase() == title.trim().toLowerCase());
    if (taskIndex != -1) {
      taskList[taskIndex].isCompleted = 1;
      taskList.refresh();
    }
  }

  Future<void> completeTaskByTitleAndDate(String title, String date) async {
    await DBHelper.completeByTitleAndDate(title, date);
    var taskIndex = taskList.indexWhere((task) => 
        task.title?.trim().toLowerCase() == title.trim().toLowerCase() &&
        task.date == date);
    if (taskIndex != -1) {
      taskList[taskIndex].isCompleted = 1;
      taskList.refresh();
    }
  }

  // =============================================================================
  // ===                 İSTEĞİN ÜZERİNE GÜNCELLENEN FONKSİYON                 ===
  // ===             Not Alanını Korur, Sadece Değişeni Günceller            ===
  // =============================================================================
  Future<void> updateTaskByTitle({
    required String oldTitle,
    String? newTitle,
    String? newDate,
    String? newTime,
    String? newNote,
  }) async {
    print("TaskController: Güncelleme işlemi başlatıldı. Eski Başlık: '$oldTitle'");
    
    // 1. Güncellenecek görevin yerel listedeki index'ini bul.
    // Büyük/küçük harf ve boşluk fark etmeksizin bulması için trim/toLowerCase kullandık.
    var taskIndex = taskList.indexWhere((task) => 
        task.title?.trim().toLowerCase() == oldTitle.trim().toLowerCase());

    // Eğer görev listede bulunamazsa, hatayı engellemek için işlemi durdur.
    if (taskIndex == -1) {
      print("TaskController: HATA - Güncellenecek görev '$oldTitle' listede bulunamadı.");
      return;
    }

    // 2. Sadece ve sadece değiştirilmesi istenen (null olmayan) verileri içeren bir harita oluştur.
    // Bu yapı, "note" gibi alanların yanlışlıkla null ile ezilmesini önler.
    final Map<String, dynamic> dataToUpdate = {};

    if (newTitle != null && newTitle.isNotEmpty) dataToUpdate['title'] = newTitle;
    if (newDate != null && newDate.isNotEmpty) dataToUpdate['date'] = newDate;
    
    // ÖNEMLİ: Eğer `newNote` null değilse (boş bir string olabilir), güncelleme haritasına ekle.
    // Eğer `newNote` null ise, bu koşul sağlanmaz ve veritabanına `note` alanı gönderilmez.
    // Böylece veritabanındaki mevcut not korunur.
    if (newNote != null) dataToUpdate['note'] = newNote;

    if (newTime != null && newTime.isNotEmpty) {
      dataToUpdate['startTime'] = newTime;
      // Başlangıç saatine göre bitiş saatini de otomatik güncelleyelim (örneğin 1 saat sonrası)
      try {
        DateTime parsedStartTime = DateFormat('hh:mm a').parse(newTime);
        DateTime calculatedEndTime = parsedStartTime.add(const Duration(hours: 1));
        dataToUpdate['endTime'] = DateFormat('hh:mm a').format(calculatedEndTime);
      } catch (e) {
        print("TaskController: Bitiş saati hesaplama hatası: $e");
      }
    }

    // Eğer güncellenecek hiçbir yeni veri yoksa, boşuna veritabanı işlemi yapma.
    if (dataToUpdate.isEmpty) {
        print("TaskController: Güncellenecek yeni bir veri sağlanmadı. İşlem durduruldu.");
        return;
    }

    // 3. Veritabanını, sadece değişiklikleri içeren bu harita ile güncelle.
    // DBHelper'daki fonksiyon bu yapıyı bekliyor.
    await DBHelper.updateTaskByTitle(
      oldTitle: oldTitle,
      dataToUpdate: dataToUpdate
    );
    
    // 4. Arayüzü anında güncellemek için YEREL LİSTEYİ de düzenle.
    // getTasks() çağrısı yapmaktan çok daha performanslıdır.
    final taskToUpdate = taskList[taskIndex];

    // `??` operatörü: "Eğer soldaki değer null ise sağdakini kullan" demektir.
    // Bu sayede sadece güncellenen alanlar değişir, diğerleri eski değerini korur.
    taskToUpdate.title = dataToUpdate['title'] ?? taskToUpdate.title;
    taskToUpdate.date = dataToUpdate['date'] ?? taskToUpdate.date;
    taskToUpdate.note = dataToUpdate['note'] ?? taskToUpdate.note; // SORUNU ÇÖZEN SATIR
    taskToUpdate.startTime = dataToUpdate['startTime'] ?? taskToUpdate.startTime;
    taskToUpdate.endTime = dataToUpdate['endTime'] ?? taskToUpdate.endTime;
    
    taskList[taskIndex] = taskToUpdate;
    taskList.refresh(); // GetX'e değişikliği arayüze yansıtmasını söyle.

    print("TaskController: Görev başarıyla güncellendi. Yeni Veriler: ${taskToUpdate.toJson()}");
  }
}