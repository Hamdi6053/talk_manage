import "package:flutter/material.dart";

class ColorsDemoView extends StatefulWidget {
  const ColorsDemoView({super.key});

  @override
  State<ColorsDemoView> createState() => _ColorsDemoView();
}

class _ColorsDemoView extends State<ColorsDemoView> {
  Color? _backgroundColor = Colors.transparent;
  void changeColor (Color color) {
    setState(() {
      _backgroundColor=color;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          if(value == MyColors.red.index){
            changeColor(Colors.red);
          } else if (value ==MyColors.blue.index){  
            changeColor(Colors.blue);
          } else if (value== MyColors.yellow.index){ 
            changeColor(Colors.yellow);
          }
        },
        items: [
        BottomNavigationBarItem(
          icon: _ColorContainer(color: Colors.red), 
          label: "Red"
        ),
        BottomNavigationBarItem(
          icon: _ColorContainer(color: Colors.yellow), 
          label: "Yellow"
        ),
         BottomNavigationBarItem(
          icon: _ColorContainer(color: Colors.blue), 
          label: "Blue"),
      ])
    );
  }
}

class _ColorContainer extends StatelessWidget {
  const _ColorContainer({required this.color}); 
  
  final Color color; 
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color, 
      height: 20,
      width: 20,
    );
  }
}


  enum MyColors{
    red,
    yellow,
    blue
  }