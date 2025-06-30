import 'package:flutter/material.dart';

class PaddingLearn extends StatelessWidget{

  const PaddingLearn({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Hamdi")),
      body: Column(
        children: [
          Padding(
                padding: const EdgeInsets.all(50),
                child: Container(color: Colors.white, height: 100)),
                Container(color:Colors.white, height: 100 , width: 50),
          Padding(
            padding: const EdgeInsets.all(100),
            child: Container(
            color:Colors.orange,height:100,width: 150,
            child: const Text("Veli")
            ),
            ), 
            ],
      )

    );
  }
}

