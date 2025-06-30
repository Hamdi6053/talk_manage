import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skd1/controllers/task_controller.dart';
import 'package:skd1/models/task.dart';
import 'package:skd1/services/theme_services.dart';
import 'package:skd1/ui/theme.dart';
import 'package:skd1/ui/add_task_bar.dart';
import 'package:skd1/ui/widgets/button.dart';
import 'package:skd1/ui/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final String _apiUrl = 'http://172.20.10.2:8000/process_command';
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  late AnimationController _micAnimationController;
  late Animation<double> _micAnimation;

  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
    _initSpeech();
    _micAnimationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _micAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(CurvedAnimation(parent: _micAnimationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _micAnimationController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      _speechEnabled = await _speechToText.initialize();
      if (mounted) setState(() {});
    } else {
      _showErrorSnackbar('Mikrofon izni reddedildi');
    }
  }

  void _startListening() async {
    if (!_speechEnabled) { _showErrorSnackbar('Ses tanıma mevcut değil'); return; }
    setState(() => _isListening = true);
    _micAnimationController.repeat(reverse: true);
    await _speechToText.listen(onResult: (result) {
      if (result.finalResult) { _processVoiceCommand(result.recognizedWords); }
    }, localeId: 'tr_TR');
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
    _micAnimationController.stop();
    _micAnimationController.reset();
  }

  void _processVoiceCommand(String command) async {
    _stopListening();
    if (command.trim().isEmpty) { _showErrorSnackbar('Ses algılanamadı.'); return; }
    _showLoadingSnackbar();
    try {
      final response = await http.post(Uri.parse(_apiUrl), headers: {'Content-Type': 'application/json; charset=UTF-8'}, body: jsonEncode({'text': command})).timeout(const Duration(seconds: 30));
      Get.back(); // Loading snackbar'ı kapat
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        _handleAgentAction(data);
      } else { _showErrorSnackbar('Asistan cevap veremedi: ${response.statusCode}'); }
    } catch (e) {
      Get.back(); // Loading snackbar'ı kapat
      _showErrorSnackbar('Asistana bağlanılamadı: $e');
    }
  }

 void _handleAgentAction(Map<String, dynamic> data) {
    String action = (data['action'] ?? 'ERROR').toLowerCase();
    Map<String, dynamic> parameters = data['parameters'] ?? {};
    String? taskName = parameters['taskName'];
    String? dateStr = parameters['dueDate'];
    String? dbFormattedDate;

    if (dateStr != null && dateStr.isNotEmpty) {
      try {
        DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(dateStr);
        dbFormattedDate = DateFormat.yMd().format(parsedDate);
      } catch (e) { print("Tarih formatı hatası: $e"); }
    }

    taskName = taskName?.trim();
    print("Agent Action: $action, TaskName: '$taskName', DBDate: '$dbFormattedDate'");

    switch (action) {
      case 'addtask':
        if (taskName == null || taskName.isEmpty) { _showErrorSnackbar('Eklenecek görev adı anlaşılamadı.'); return; }
        DateTime taskDate = (dateStr != null && dateStr.isNotEmpty) ? DateFormat('yyyy-MM-dd').parse(dateStr) : DateTime.now();
        String? timeStr = parameters['time'];
        DateTime startTime;
        if (timeStr != null && timeStr.isNotEmpty) {
          timeStr = timeStr.replaceAll('.', ':'); 
          try {
            List<String> timeParts = timeStr.split(':');
            startTime = DateTime(taskDate.year, taskDate.month, taskDate.day, int.parse(timeParts[0]), int.parse(timeParts[1]));
          } catch(e) {
            startTime = DateTime(taskDate.year, taskDate.month, taskDate.day, DateTime.now().hour, DateTime.now().minute);
          }
        } else {
          startTime = DateTime(taskDate.year, taskDate.month, taskDate.day, DateTime.now().hour, DateTime.now().minute);
        }
        DateTime endTime = startTime.add(Duration(minutes: (parameters['duration'] as int?) ?? 60));
        final newTask = Task(
          title: taskName, note: parameters['notes'] ?? '', isCompleted: 0,
          date: DateFormat.yMd().format(taskDate), startTime: DateFormat('hh:mm a').format(startTime),
          endTime: DateFormat('hh:mm a').format(endTime), color: 0,
          remind: (parameters['remind'] as int?) ?? 5, repeat: parameters['repeat'] ?? 'None',
        );
        _taskController.addTask(task: newTask);
        _showSuccessSnackbar('Görev eklendi: "$taskName"');
        break;

      case 'deletetask':
        if (taskName == null || taskName.isEmpty) { _showErrorSnackbar('Silinecek görev adı anlaşılamadı.'); return; }
        _taskController.deleteTaskByTitle(taskName);
        _showSuccessSnackbar('Görev silindi: "$taskName"');
        break;

      case 'completetask':
        if (taskName == null || taskName.isEmpty) { _showErrorSnackbar('Tamamlanacak görev adı anlaşılamadı.'); return; }
        _taskController.completeTaskByTitle(taskName);
        _showSuccessSnackbar('Görev tamamlandı: "$taskName"');
        break;

      case 'updatetask':
        if (taskName == null || taskName.isEmpty) {
          _showErrorSnackbar('Güncellenecek görev adı anlaşılamadı.');
          return;
        }

        String? newTitle = parameters['newTitle'];
        String? newNote = parameters['notes'];
        String? timeStr = parameters['time'];
        String? newStartTime;

        // ======================= YENİ EKLENEN KONTROL =======================
        // API'den gelen başlık veya not "boş string" ise, bunu bir değişiklik
        // olarak kabul etme ve null'a çevir. Bu, TaskController'daki
        // koruma mekanizmasının doğru çalışmasını sağlar.
        if (newTitle != null && newTitle.isEmpty) {
          newTitle = null;
        }
        if (newNote != null && newNote.isEmpty) {
          newNote = null;
        }
        // ===================================================================

        if (timeStr != null && timeStr.isNotEmpty) {
            timeStr = timeStr.replaceAll('.', ':');
            try {
                List<String> timeParts = timeStr.split(':');
                DateTime parsedTime = DateTime(2000, 1, 1, int.parse(timeParts[0]), int.parse(timeParts[1]));
                newStartTime = DateFormat('hh:mm a').format(parsedTime);
            } catch(e) {
                print("Güncelleme için saat parse hatası: $e");
            }
        }
        
        _taskController.updateTaskByTitle(
          oldTitle: taskName,
          newTitle: newTitle,      // Artık "" yerine null gidecek (eğer boşsa)
          newDate: dbFormattedDate,
          newTime: newStartTime,
          newNote: newNote,        // Artık "" yerine null gidecek (eğer boşsa)
        );
        _showSuccessSnackbar('Görev güncellendi: "$taskName"');
        break;
        
      case 'error':
          _showErrorSnackbar(parameters['message'] ?? 'Bilinmeyen bir hata oluştu.');
          break;

      default:
        _showErrorSnackbar('Asistandan anlaşılmayan bir cevap alındı: $action');
    }
}

  void _showErrorSnackbar(String message) { Get.snackbar("Hata", message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red[400], colorText: Colors.white); }
  void _showSuccessSnackbar(String message) { Get.snackbar("Başarılı", message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green[400], colorText: Colors.white); }
  void _showLoadingSnackbar() { Get.snackbar("İşleniyor...", "Asistan komutunuzu düşünüyor.", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.grey[800], colorText: Colors.white, showProgressIndicator: true, isDismissible: false, duration: const Duration(seconds: 30)); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _appBar(context),
      body: Stack(
        children: [
          Column(
            children: [
              _addTaskBar(),
              const SizedBox(height: 10),
              _showTasks(),
            ],
          ),
          if (_isListening)
            Container(color: Colors.black.withOpacity(0.5), child: Center(child: ScaleTransition(scale: _micAnimation, child: Container(padding: const EdgeInsets.all(40), decoration: const BoxDecoration(shape: BoxShape.circle, color: primaryClr), child: const Icon(Icons.mic, color: Colors.white, size: 50))))),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _isListening ? _stopListening : _startListening, backgroundColor: _isListening ? Colors.red : primaryClr, child: Icon(_isListening ? Icons.stop : Icons.mic, color: Colors.white, size: 28)),
    );
  }

  Widget _showTasks() {
    return Expanded(
      child: Obx(() {
        final List<Task> activeTasks = _taskController.taskList.where((task) {
          if (task.isCompleted == 1) return false;
          if (task.repeat == 'Daily') return true;
          if (task.repeat == 'Weekly') {
            try {
              DateTime taskDate = DateFormat.yMd().parse(task.date!);
              return taskDate.weekday == _selectedDate.weekday && taskDate.isBefore(_selectedDate.add(const Duration(days: 1)));
            } catch(e) { return false; }
          }
          if (task.repeat == 'Monthly') {
            try {
              DateTime taskDate = DateFormat.yMd().parse(task.date!);
              return taskDate.day == _selectedDate.day && taskDate.isBefore(_selectedDate.add(const Duration(days: 1)));
            } catch(e) { return false; }
          }
          return task.date == DateFormat.yMd().format(_selectedDate);
        }).toList();

        final List<Task> completedTasks = _taskController.taskList.where((task) => task.isCompleted == 1 && task.date == DateFormat.yMd().format(_selectedDate)).toList();

        try {
          activeTasks.sort((a, b) => DateFormat('hh:mm a').parse(a.startTime!).compareTo(DateFormat('hh:mm a').parse(b.startTime!)));
        } catch (e) { /* ignore */ }

        if (activeTasks.isEmpty && completedTasks.isEmpty) return _noTaskMsg();

        return ListView.builder(
          itemCount: activeTasks.length + (completedTasks.isNotEmpty ? 1 : 0) + completedTasks.length,
          itemBuilder: (context, index) {
            if (index < activeTasks.length) { return _buildTaskItem(activeTasks[index]); }
            if (completedTasks.isNotEmpty && index == activeTasks.length) { return _buildCompletedHeader(completedTasks.length); }
            return _buildTaskItem(completedTasks[index - activeTasks.length - 1]);
          },
        );
      }),
    );
  }

  Widget _buildTaskItem(Task task) {
    return AnimationConfiguration.staggeredList(
      position: task.id ?? 0, duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        horizontalOffset: 300.0,
        child: FadeInAnimation(child: GestureDetector(onTap: () => _showTaskActions(context, task), child: TaskTile(task))),
      ),
    );
  }

  void _showTaskActions(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Wrap(
          children: [
            if (task.isCompleted == 0)
              _bottomSheetTile(label: "Görevi Tamamla", onTap: () {
                _taskController.markTaskCompleted(task.id!);
                Get.back();
              }, clr: primaryClr, icon: Icons.check),
            _bottomSheetTile(label: "Görevi Sil", onTap: () {
              _taskController.delete(task); Get.back();
            }, clr: Colors.red[400]!, icon: Icons.delete_outline),
            const Divider(),
            _bottomSheetTile(label: "Kapat", onTap: () => Get.back(), clr: Get.isDarkMode ? Colors.white : Colors.black, isClose: true),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheetTile({required String label, required Function() onTap, required Color clr, IconData? icon, bool isClose = false}) {
    return ListTile(
      leading: isClose ? null : Icon(icon, color: clr),
      title: Text(label, style: isClose ? titleTextStyle : titleTextStyle.copyWith(color: clr)),
      onTap: onTap,
    );
  }

  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2101), builder: (context, child) {
      return Theme(data: Get.isDarkMode ? ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: primaryClr, onPrimary: Colors.white, surface: darkGreyClr, onSurface: Colors.white), dialogBackgroundColor: darkGreyClr) : ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: primaryClr, onPrimary: Colors.white)), child: child!);
    });
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() { _selectedDate = pickedDate; });
    }
  }

Widget _addTaskBar() {
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat.yMMMMd().format(_selectedDate), style: subHeadingStyle),
            Text(_getDateHeaderText(), style: headingStyle)
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () async {
                await Get.to(() => const AddTaskPage());
                _taskController.getTasks();
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: primaryClr,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 4.0), 
            IconButton(
              iconSize: 32.0, 
              splashRadius: 20,
              icon: Icon(
                Icons.filter_alt_outlined,
                color: Get.isDarkMode ? Colors.white : darkGreyClr,
              ),
              onPressed: () => _pickDate(context),
              tooltip: "Tarihi Değiştir",
            ),
          ],
        )
      ],
    ),
  );
}

  String _getDateHeaderText() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime selected = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    if (selected == today) { return "Today"; }
    else if (selected == today.add(const Duration(days: 1))) { return "Tomorrow"; }
    else if (selected == today.subtract(const Duration(days: 1))) { return "Yesterday"; }
    else { return DateFormat.EEEE().format(_selectedDate); }
  }

  _appBar(BuildContext context) {
    return AppBar(elevation: 0, backgroundColor: context.theme.scaffoldBackgroundColor, leading: GestureDetector(onTap: () { ThemeServices().switchTheme(); }, child: Icon(Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round, size: 24, color: Get.isDarkMode ? Colors.white : Colors.black)), actions: const [CircleAvatar(backgroundImage: AssetImage("assets/profile.png"), radius: 18), SizedBox(width: 20)]);
  }

  Widget _noTaskMsg() {
    return Center(child: SingleChildScrollView(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.check_circle_outline, size: 90, color: Colors.grey.withOpacity(0.5)),
      const Padding(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), child: Text("Harika! Bu tarihe ait görev yok.\nSesli komutla veya butona basarak yeni görev ekleyin!", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)))])));
  }

  Widget _buildCompletedHeader(int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      child: InkWell(
        onTap: () => _showCompletedTasksMenu(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Text("Tamamlananlar ($count)", style: headingStyle.copyWith(fontSize: 18)),
            const Spacer(),
            const Icon(Icons.more_vert, size: 24, color: Colors.grey),
          ]),
        ),
      ),
    );
  }

  void _showCompletedTasksMenu(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4, bottom: 10),
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Wrap(
          children: <Widget>[
            ListTile(title: Text('Sıralama ölçütü', style: subHeadingStyle.copyWith(color: Colors.grey))),
            ListTile(
              leading: const Icon(Icons.sort, color: primaryClr), title: const Text('Tarih'),
              trailing: const Icon(Icons.check, color: primaryClr), onTap: () => Get.back(),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
              title: const Text('Tamamlanan tüm görevleri sil', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                _taskController.deleteAllCompletedTasks();
                _showSuccessSnackbar("Tüm tamamlanmış görevler silindi.");
              },
            ),
          ],
        ),
      ),
    );
  }
}