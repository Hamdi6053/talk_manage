import 'package:flutter/material.dart';

class CustomRowView extends StatelessWidget {
  const CustomRowView({super.key});
  final String title1 = "DATA";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.pinkAccent,
              ),
            ),
          ),
          Row(
            children: [
              Text(title1),
              Text(title1),
        
            ],
          ),
          Expanded(flex: 4,child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("Aferin"),
              const Text("Aferin"),
              const Text("Aferin"),
            ],
            )),


          Expanded(flex: 2,child: Container(color:Colors.brown)),
          Expanded(flex: 1,child: Container(color:Colors.purple)),
          Expanded(flex: 3,child: Container(color:Colors.yellow)),

          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.purpleAccent,
            ),
          ),
          SizedBox(
            height: 15,
            width: 15,
          ),
           Center(child:Text(
                "Hamdi",
                style: TextStyle(
                  color:Colors.orange,
                  fontSize: 50,
                  fontWeight: FontWeight.w600

                )),
              ),
        ],
      ),
    );
  }
}
