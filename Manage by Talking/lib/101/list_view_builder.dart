import "package:flutter/material.dart";

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewLearn();
}

class _ListViewLearn extends State<ListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView.separated(
        itemCount: 15,
        separatorBuilder: (context,Index) {
        return const Divider(
          color:Colors.white,
        );
      },
      itemBuilder: (context,index) {
        print(index);
        return Column(
          children: [Image.network("https://picsum.photos/200"),Text("$index")],
        );
       
      }

    ),
    );
  }
}