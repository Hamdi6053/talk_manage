import 'package:flutter/material.dart';
import 'package:skd1/models/task.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skd1/ui/theme.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  const TaskTile(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = task?.isCompleted == 1;

    // *** RENK SORUNUNUN ÇÖZÜMÜ BURADA ***
    // Önce, aktif bir görev için doğru rengi seçen bir fonksiyon tanımlıyoruz.
    // Bu, senin add_task_bar'daki renk mantığının aynısı.
    Color _getTaskColor() {
    switch (task?.color ?? 0) {
      case 0:
        return Colors.green; // Senin kodunla eşleşti
      case 1:
        return primaryClr;   // Senin kodunla eşleşti
      case 2:
        return Colors.purple;// Senin kodunla eşleşti
      default:
        return primaryClr;   // Varsayılan olarak ana renk
    }
  }

    // Şimdi, rengi güvenle bir değişkene atıyoruz.
    final Color tileColor = isCompleted 
        ? Colors.grey[800]!       // Tamamlanmış görevler için koyu gri
        : _getTaskColor();        // Aktif görevler için görevden gelen rengi kullan

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // Ve burada güvenle renk değişkenimizi kullanıyoruz.
          color: tileColor,
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task?.title ?? "",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.white.withOpacity(0.7) : Colors.white,
                      decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                      decorationColor: Colors.white.withOpacity(0.8),
                      decorationThickness: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: isCompleted ? Colors.grey[400] : Colors.grey[200],
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${task!.startTime} - ${task!.endTime}",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 13,
                          color: isCompleted ? Colors.grey[300] : Colors.grey[100],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  task?.note ?? "",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 15,
                      color: isCompleted ? Colors.grey[300] : Colors.grey[100],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          isCompleted
              ? const Icon(Icons.check_circle_outline, color: Colors.white70, size: 26)
              : const Icon(Icons.radio_button_unchecked, color: Colors.white, size: 26),
        ]),
      ),
    );
  }
}