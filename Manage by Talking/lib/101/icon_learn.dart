import 'package:flutter/material.dart';

class IconLearnView extends StatelessWidget {
  const IconLearnView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ali")),
      body: Column(
        children: [IconButton(onPressed: () {}
        , icon: Icon(Icons.message_outlined,color: Colors.red,size : 40)
        )],
      
      ),
    );
  }
}


class IconSizes {
  final int iconSmall = 40;
}

class IconColors {
  final Color froly = const Color(0xffED617A);

}
