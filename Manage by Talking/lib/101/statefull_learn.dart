import "package:flutter/material.dart";

class StatefullLearn extends StatefulWidget {
  const StatefullLearn({super.key});

  @override
  State<StatefullLearn> createState() => _StatefullLearn();
}

class _StatefullLearn extends State<StatefullLearn> {
  int countValue = 0;
  int counterCustom = 0;

  void incrementValue() {
    setState(() {
      countValue = countValue + 1;
    });
  }

  void deincrementValue() {
    setState(() {
      countValue = countValue - 1;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              incrementValue();
            },
            child: Icon(Icons.add),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: FloatingActionButton(
              onPressed: () {
                deincrementValue();
              },
              child: Icon(Icons.remove),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              countValue.toString(),
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const Placeholder(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                ++counterCustom;
              });
            },
            child:Text("Merhaba $counterCustom"))  
        ],
      ),
    );
  }
}
