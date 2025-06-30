import "package:flutter/material.dart";

class StatefullLifeCycleLearn extends StatefulWidget {
  const StatefullLifeCycleLearn({super.key,required this.message});
  final String message;
  @override
  State<StatefullLifeCycleLearn> createState() => _StatefullLifeCycleLearn();
}

class _StatefullLifeCycleLearn extends State<StatefullLifeCycleLearn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Center(child: widget.message.length.isOdd ? const Text("Kelime Tek") : const Text("Kelime Cift")),
      ),
      body: widget.message.length.isOdd ? TextButton(onPressed: () {}
     , child: Text(widget.message)): ElevatedButton(onPressed: () {}, child: Text(widget.message))
    );
  }
}