import 'package:flutter/material.dart';
import 'package:skd1/controllers/task_controller.dart';
import 'package:skd1/ui/theme.dart';
import 'package:skd1/ui/widgets/button.dart';
import "package:get/get.dart";
import 'package:skd1/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';
import "package:skd1/models/task.dart";
// DOĞRU İMPORT YOLU - Bir önceki adımda oluşturduğumuz helper'ı import ediyoruz.
// Eğer dosyanın adı veya konumu farklıysa, lütfen burayı güncelleyin.
import 'package:skd1/services/notification_services.dart'; 

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  // HATA 1 DÜZELTİLDİ: Bu satır tamamen kaldırıldı çünkü artık NotifyHelper'dan nesne oluşturmuyoruz.
  // final NotifyHelper _notifyHelper = NotifyHelper(); 

  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
     5,10,15,20
  ];
  String _selectRepeat = "None";
  List<String> repatList=[
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];
  int _selectedColor=0;
  
  @override
  Widget build(BuildContext context) {
    // ... widget ağacınızın geri kalanı aynı kalabilir ...
    // ... (build metodu içeriği değişmediği için kısaltıyorum) ...
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Task", style: headingStyle),
              MyInputField(title: "Title", hint: "Enter your title",controller: _titleController,),
              MyInputField(title: "Note", hint: "Enter your note",controller:_noteController),
              MyInputField(
                title: "Date", 
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  }, 
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time", 
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: Icon(Icons.access_time_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: MyInputField(
                      title: "End Time", 
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(Icons.access_time_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: "Remind", 
                hint: "$_selectedRemind minute early", 
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: "Repeat", 
                hint: "$_selectRepeat ", 
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectRepeat = newValue!;
                    });
                  },
                  items: repatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value, style: TextStyle(color:Colors.grey),),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 _colorPallete(),
                 MyButton(label: "Create Task", onTap: ()=>_validateDate())
                ],
              )            
            ],
          ),
        ),
      ),
    );
  }
 
  _validateDate() async {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      final task = await _addTaskToDb();
      if (task != null) {
        // HATA 2 DÜZELTİLDİ: Metodu doğrudan sınıf adı üzerinden çağırıyoruz.
        await NotifyHelper.scheduleTaskNotification(task);
        Get.back();
      }
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.grey[800] : Colors.grey[300],
        colorText: Get.isDarkMode ? Colors.white : Colors.black,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red),
        margin: EdgeInsets.all(20),
        borderRadius: 12,
        snackStyle: SnackStyle.FLOATING,
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
        duration: Duration(seconds: 3),
      );
    }
  }

  // ... Geri kalan tüm metotlarınız (_addTaskToDb, _colorPallete, vb.) aynı kalabilir ...
  // ... (değişmedikleri için kısaltıyorum) ...
  Future<Task?> _addTaskToDb() async {
    try {
      int value = await _taskController.addTask(
        task: Task(
          note: _noteController.text,
          title: _titleController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectRepeat,
          color: _selectedColor,
          isCompleted: 0,
        ),
      );
      print("Task ID is $value");
      
      return Task(
        id: value,
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectRepeat,
        color: _selectedColor,
        isCompleted: 0,
      );
    } catch (e) {
      print("Error adding task to database: $e");
      return null;
    }
  }

  Widget _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleTextStyle,
        ),
        const SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            Color color;
            switch (index) {
              case 0:
                color = Colors.green;
                break;
              case 1:
                color = primaryClr;
                break;
              case 2:
                color = Colors.purple;
                break;
              default:
                color = Colors.grey;
            }
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                  print("Selected color index: $index");
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: color,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
     actions: const [
          CircleAvatar(
            backgroundImage: AssetImage("assets/profile.png"),
            radius: 18,
          ),
          SizedBox(width: 20),
        ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
        print(_selectedDate);
      });
    } else {
      print("it's null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await _showTimePicker();

    if (pickedTime == null) {
      print("Time cancelled");
    } else {
      String formattedTime = pickedTime.format(context);
      setState(() {
        if (isStartTime == true) {
          _startTime = formattedTime;
        } else if (isStartTime == false) {
          _endTime = formattedTime;
        }
      });
    }
  }

  Future<TimeOfDay?> _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}