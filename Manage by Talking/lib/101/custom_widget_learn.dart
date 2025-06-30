import "package:flutter/material.dart";

class CustomWidgetLearn extends StatelessWidget {
  const CustomWidgetLearn({super.key});
  final String title = "Food";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:Column(
        children: [
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: 
          ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          onPressed: () {}, 
          child: Center(child:Text(title))))
        ],
      ) 
    );
  }
}
