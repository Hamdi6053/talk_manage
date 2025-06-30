class PostModel10 {
  int? userId;
  int? id;
  String? title;
  String? body;  //Servisten her zaman data gelmeyebilir o yüzden burası null ? bu yüzden koyduk geledebilir gelmeyedebilir.

  PostModel10({this.userId, this.id, this.title, this.body});

  PostModel10.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    return data;
  }
}

// Buraya asla kod yazılmaz servisten datayı alır datayı verir.