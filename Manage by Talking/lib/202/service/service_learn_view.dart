import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:skd1/202/service/post_model.dart";

class ServiceLearnView extends StatefulWidget {
  const ServiceLearnView({super.key});

  @override
  State<ServiceLearnView> createState() => _ServiceLearnViewState();
}

class _ServiceLearnViewState extends State<ServiceLearnView> {
  List<PostModel10>? _items;  // API'den gelen veriler
  String name = "Hamdi";      // AppBar başlığı

  @override
  void initState() {
    super.initState();
    fetchPostItems();  // Sayfa açılınca verileri çek
  }

  Future<void> fetchPostItems() async {
    final response =
        await Dio().get("https://jsonplaceholder.typicode.com/posts");

    if (response.statusCode == 200) {
      final List jsonData = response.data;
      setState(() {
        _items = jsonData.map((e) => PostModel10.fromJson(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20), 
        child: ListView.builder(
          itemCount: _items?.length ?? 0,
          itemBuilder: (context, index) {
            final item = _items![index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(item.title ?? "No title"),
                subtitle: Text(item.body ?? ""),
              ),
            );
          },
        ),
      ),
    );
  }
}
