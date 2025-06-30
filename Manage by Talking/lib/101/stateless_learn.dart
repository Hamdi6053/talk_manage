import 'package:flutter/material.dart';

class StateLearn extends StatelessWidget{
  const StateLearn({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
     body:Column(
      children: [
        SizedBox(
          height: 100,
        ),
        TitleTextWidget(),
        TitleTextWidget(),
        TitleTextWidget(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.red,
          
          ),

          ),
        
      ],
     )
    );
  }
}


class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({super.key});
  @override
  Widget build(BuildContext context){
    return Text(
      "data",
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
  
}
