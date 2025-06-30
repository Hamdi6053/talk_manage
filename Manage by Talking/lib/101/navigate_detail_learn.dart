import "package:flutter/material.dart";

class NavigateDetailLearn extends StatefulWidget {
  const NavigateDetailLearn({super.key});

  @override
  State<NavigateDetailLearn> createState() => _NavigateDetailLearnState();
}

class _NavigateDetailLearnState extends State<NavigateDetailLearn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(),
       body: Center(
        child: ElevatedButton.icon(onPressed: (){}, label: Text("Onayla"),icon: Icon(Icons.check),)
       )
    );
  }
}