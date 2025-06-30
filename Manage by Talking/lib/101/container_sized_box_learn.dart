import 'package:flutter/material.dart';

class ContainerSizedBoxLearn extends StatelessWidget {
  const ContainerSizedBoxLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            width: 300,
            height: 200,
            child: Text('a' * 500),
          ),
          const SizedBox.shrink(),
          SizedBox.square(
            dimension: 100,
            child: Text('b' * 1000),
          ),
          Container(
            width: 200,
            height: 100,
            constraints: const BoxConstraints(
              minWidth: 100,
              maxWidth: 300,
              minHeight: 50,
              maxHeight: 200,
            ),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                width: 10,
                color: const Color.fromARGB(255, 144, 255, 64),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
