import 'package:flutter/material.dart';

class Buttonlearn extends StatelessWidget {
  const Buttonlearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextButton(
            onPressed: () {}, // Butona tıklandığında çalışacak fonksiyon
            child: const Text(
              "Bana Tıkla",
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("data"),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.abc_rounded),
          ),
          FloatingActionButton(
            onPressed: () {
              // Sayfanın rengini düzenlemede, servise istek atmada kullanılabilir.
            },
            child: const Icon(Icons.add),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 244, 54, 203),
            ),
            onPressed: () {},
            child: const Text("Prenses..."),
          ),
          InkWell(
            onTap: () {},
            child: const Text(
              "InkWell Butonu",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          Container(
            height: 300,
            width: 500,
            color: Colors.blue,
          ),
          SizedBox(
            height: 20,
            width: 15,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(184, 0, 0, 0), 
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))
              )
            ),
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20, right: 40, left: 40),
              child: Text(
                'Place Bid',
                style: Theme.of(context).textTheme.headlineSmall, 
              ),
            ),
          ), 
        ],
      ),
    );
  }
}