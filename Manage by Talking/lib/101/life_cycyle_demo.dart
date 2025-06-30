import "package:flutter/material.dart";
import "colors_demo_view.dart";
class LifeCycyleDemo extends StatefulWidget {
  const LifeCycyleDemo ({super.key,required this.initialcolor});
  final Color initialcolor;
  @override
  State<LifeCycyleDemo > createState() => _LifeCycyleDemo();
}

class _LifeCycyleDemo extends State<LifeCycyleDemo > {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       actions: [IconButton(onPressed:(){}, icon: Icon(Icons.clear))],
      ),
  
      body:Column(
        children: [
          Spacer(),
          Expanded(child:ColorsDemoView()),
        ],
      )
    );
  }
}