import "package:flutter/material.dart";

class ImageLearn extends StatelessWidget{
  const ImageLearn({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Center(child:Text(
        "TO DO LİST APP",
        style: TextStyle(
          fontSize: 21,
          color: Colors.amber
        ),)),),
      body:Column(
        children: [
          SizedBox(
            height: 100,
            width: 150,
            child: Image.asset(
              ImageItems().appleWithBook,
              fit: BoxFit.contain
              ),
          ),
          Image.network("https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.cleanpng.com%2Fpng-apple-pencil-book-fall-apples-crisp-and-juicy-clip-884333%2F&psig=AOvVaw05erWIXDSF9ubYbm7t_AQj&ust=1748685752726000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCMi5oJv4yo0DFQAAAAAdAAAAABAE"),
        ],
      )
    );
  }
}

class ImageItems{
  final String appleWithBook = "assets/mini_proje_resim.jpg";
}