import 'package:flutter/material.dart';

class StackLearn extends StatelessWidget {
  const StackLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Image.asset("assets/apple1.png"),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Card(
                    color: Colors.grey,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 6),
        ],
      ),
    );
  }
}
