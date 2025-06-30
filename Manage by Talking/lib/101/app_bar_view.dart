import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarLearnView extends StatelessWidget {
  const AppBarLearnView({super.key});
  final String _title = 'Welcome Learn';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_title),
        leading: const Icon(Icons.chevron_left),// Geriye dönüş sayfaları için kullanılır.
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actionsIconTheme: const IconThemeData(color:Colors.red),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mark_email_unread_sharp),
          ),
          const Center(child: CircularProgressIndicator()),
        ],
      ),
      body: Column(children: const []),
    );
  }
}