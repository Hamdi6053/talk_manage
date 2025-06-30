import "package:flutter/material.dart";
import "navigate_detail_learn.dart"; // ListViewLearn sayfasını içeren dosya (gerekliyse)

class NavigationLearn extends StatefulWidget {
  const NavigationLearn({super.key});

  @override
  State<NavigationLearn> createState() => _NavigationLearnState();
}

class _NavigationLearnState extends State<NavigationLearn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemBuilder:(context,index) {
        return Placeholder(color:Colors.red);
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return NavigateDetailLearn(); 
              },
              fullscreenDialog: true,
              settings: RouteSettings()
            ),
          );
        },
        child: Icon(Icons.navigation_rounded),
      ),
    );
  }
}
