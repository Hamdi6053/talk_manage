import "package:flutter/material.dart";

class IndicatorLearn extends StatelessWidget{
  const IndicatorLearn({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        actions: [Center(child:CircularProgressIndicator(color: Colors.orange))],
      ),
      body: Center(
        child: CircularProgressIndicator(color: Colors.orange,),
      )

    );
  }
}