import "package:flutter/material.dart";

class CardLearn extends StatelessWidget{
  const CardLearn({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
    appBar: AppBar(),
    body:Column(
      children: [
        Card(
          margin: ProjectMargins.cardMargin,
          color : Theme.of(context).colorScheme.error,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), // Bu satıır tekrar et mutlaka!!
          child: SizedBox(height:100,width:200),
          ),
        Card(
        margin : ProjectMargins.cardMargin,
        child: const SizedBox(
          height:150,
          width: 150,
          child: Center(child:Text("Data")),
        ),
        )

        
      ],
    )
    );
  }
}

class ProjectMargins{
  static const cardMargin = EdgeInsets.all(10);
}

//Borders
//StadiumBorder(),CircleBorder,RoundedRectangeBorder()

