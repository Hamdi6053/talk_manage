import 'package:flutter/material.dart';
import 'package:skd1/ui/theme.dart';
import "package:get/get.dart";

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  
  const MyInputField({
    super.key,
    required this.title, 
    required this.hint,
    this.controller,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, 
            style: titleTextStyle,
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: Get.isDarkMode ? Colors.grey[600]! : Colors.grey[400]!,
                width: 1.0
              ),
              borderRadius: BorderRadius.circular(12),
              // Arka plan rengini daha belirgin yaptım
              color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    cursorColor: Get.isDarkMode ? Colors.white : Colors.black,
                    controller: controller,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      // Hint text rengini daha belirgin yaptım
                      hintStyle: subTitleStyle.copyWith(
                        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                widget == null 
                  ? const SizedBox.shrink() 
                  : Container(
                      padding: const EdgeInsets.only(right: 8),
                      child: widget,
                    )
              ],
            ),
          )
        ],
      ),
    );
  }
}