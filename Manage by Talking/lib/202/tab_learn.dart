
import "package:flutter/material.dart";

class TabLearn extends StatefulWidget {
  const TabLearn({super.key});

  @override
  State<TabLearn> createState() => _TabLearnState();
}

class _TabLearnState extends State<TabLearn> with TickerProviderStateMixin{
  late final TabController _tabController;

  @override

  void initState(){
    super.initState();
    _tabController = TabController(length: 2, vsync:this);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length:2, child: Scaffold(
    extendBody: true,
     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
     floatingActionButton: FloatingActionButton(onPressed: (){
      _tabController.animateTo(0);
     }),
     bottomNavigationBar:BottomAppBar(
      notchMargin:10,
      shape: CircularNotchedRectangle(),
      child: TabBar(
      indicatorColor: Colors.white,
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.green,
      indicatorSize: TabBarIndicatorSize.label,
      controller: _tabController,tabs:const[
      Tab(text:"Page One"),
      Tab(text:"Page Two")]),
     ),
      appBar: AppBar(bottom: TabBar(tabs:
       [Tab(text:"Page One"),
       Tab(text:"Page Two")]),),
      body: TabBarView(controller: _tabController,children: [
        Container(color:Colors.red),
        Container(color: Colors.blue)
      ])
    ));
  }
}
