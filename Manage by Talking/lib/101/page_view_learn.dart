import "package:flutter/material.dart";

class PageViewLearn extends StatefulWidget {
  const PageViewLearn({super.key});

  @override
  State<PageViewLearn> createState() => _PageViewLearn();
}

class _PageViewLearn extends State<PageViewLearn> {
  final _pageController = PageController(viewportFraction: 0.8);
  int _currentPageIndex = 0;
  void _updatePageIndex(int index){
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        children: [
          Padding(
          padding:EdgeInsets.only(left:20),
          child: Text(_currentPageIndex.toString()),
          ),
          const Spacer(),
          FloatingActionButton(onPressed:() {
            _pageController.nextPage(duration:Duration(seconds: 1), curve: Curves.slowMiddle);
          },child:Icon(Icons.arrow_back),),
          const Spacer(),
          FloatingActionButton(onPressed: () {
            _pageController.previousPage(duration: Duration(seconds:1), curve: Curves.slowMiddle);
          },child:Icon(Icons.arrow_forward)),
       ],
      ),
      appBar: AppBar(),
      body:PageView(
        padEnds: true,
        controller: _pageController,
        onPageChanged: _updatePageIndex,
        children: [
          Container(
            color:Colors.red
          ),
          Container(
            color:Colors.blue
          ),
          Container(
            color:Colors.green      
          ),
        ],
      )
    );
  }
}