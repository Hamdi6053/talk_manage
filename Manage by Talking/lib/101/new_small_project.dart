import "package:flutter/material.dart";

class ViewLearn extends StatelessWidget {
  const ViewLearn({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
    ),
    body:Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Image.asset("assets/apple1.png",
          fit:BoxFit.fill),
          SizedBox(
            height: 20,
          ),
          Text(
            "Create your first note",
            style: TextStyle(
              fontSize:25,
              color: Colors.blue,
              fontWeight: FontWeight.w700
            ),  
          ),
          SizedBox(
            height: 15,
          ),
          Text("Add a note" * 10,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:20,
            color: Colors.white,
            fontWeight: FontWeight.w500
          )),
          const Spacer(),
          ElevatedButton(
          onPressed:() {},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const SizedBox(
           child:Center(child:Text("Create a Note", style:TextStyle(
            fontSize:20,
            color:Colors.white
           ))),
           )),
           TextButton(
            onPressed: () {}, 
            child: const Text("Import Notes",style: TextStyle(fontSize: 17),)),
            const SizedBox(
              height: 50,
            )
        ],
      ),
    )
    
    );
  }
}