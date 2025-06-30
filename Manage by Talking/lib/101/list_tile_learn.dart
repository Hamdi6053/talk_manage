import "package:flutter/material.dart";

class ListTileLearn extends StatelessWidget{
  const ListTileLearn({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:Column(
        children: [
          Padding(
          padding: EdgeInsets.all(20),
          child: Image.asset("assets/mini_proje_resim.jpg",
          height: 300,
          width: 300,
          fit:BoxFit.cover)
          ),
          ListTile(
            title: const Text("My Card"),
            onTap: () {},
            subtitle: const Text("How do you use your card"),
            leading: Icon(Icons.money),
            trailing:Icon(Icons.chevron_right)
            ),
        ],
      )

    );
  }
}