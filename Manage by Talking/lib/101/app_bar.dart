import 'package:flutter/material.dart';

class AppbarLearn extends StatelessWidget {
  const AppbarLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("To Do List App")),
      drawer: Drawer(),
      body: Column(
        children: [
          const Text(
            "To Do List",
            style: TextStyle(
              fontSize: 23,
              color: Colors.blue,
            ),
          ),
        
          ElevatedButton(
            onPressed: () {},
            child: const Text("Görev Ekle"),
          ),
          Container(
            height: 20,
            width: 20,
            constraints: BoxConstraints(
              maxHeight: 200,
              minHeight: 100,
              minWidth: 100,
              maxWidth: 150,

            ),
          )
        ],
      ),
    );
  }
}
