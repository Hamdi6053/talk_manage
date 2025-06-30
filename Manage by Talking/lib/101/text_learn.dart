import "package:flutter/material.dart";

class TextLearnView extends StatelessWidget {
  const TextLearnView({super.key});
  
  final String name = "Hamdi";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          // Widget'ları dikey hizalayacak comlunm ile birden fazla widget gösterileck ise center içine column konulmalı.
          mainAxisAlignment: MainAxisAlignment.center, // Ortala
          children: [
            Text(
              'Hello Flutter! $name',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 33, 243, 110),
                wordSpacing: 2,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
            Text(
              'Hello Flutter! $name',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: ProjectStyless.welcomeTextStyle,
              
            ),
          ],
        ),
      ),
    ); 
  }
}

class ProjectStyless {
  static TextStyle welcomeTextStyle = const TextStyle(
    fontSize: 24,
    color: Color.fromARGB(255, 64, 255, 198),
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    wordSpacing: 2,
    decoration: TextDecoration.underline
  );
}

