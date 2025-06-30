import "package:flutter/material.dart";

class TextFieldLearn extends StatefulWidget {
  const TextFieldLearn({super.key});

  @override
  State<TextFieldLearn> createState() => _TextFieldLearn();
}

class _TextFieldLearn extends State<TextFieldLearn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20), 
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          maxLength: 20,
          buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) {
            return Container(
              height: 30,
              width:30,
              color:Colors.blue

            );
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail), 
            border: OutlineInputBorder(),
            labelText: "E-Posta",
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
