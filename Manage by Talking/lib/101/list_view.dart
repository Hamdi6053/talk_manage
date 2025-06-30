import "package:flutter/material.dart";

class ListViewLearn extends StatefulWidget {
  const ListViewLearn({super.key});

  @override
  State<ListViewLearn> createState() => _ListViewLearn();
}

class _ListViewLearn extends State<ListViewLearn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text(
            "Flutter ListView",
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          Container(
            color: Colors.blue,
            height: 200,
          ),

          const Divider(),

          SizedBox(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(color: Colors.blue, width: 200),
                Container(color: Colors.orange, width: 200),
                Container(color: Colors.yellow, width: 200),
              ],
            ),
          ),

          SizedBox(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(color: Colors.green, width: 200),
                Container(color: Colors.purple, width: 200),
                Container(color: Colors.pink, width: 200),
              ],
            ),
          ),

          SizedBox(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(color: Colors.grey, width: 200),
                Container(color: Colors.brown, width: 200),
                Container(color: Colors.pink, width: 200),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
