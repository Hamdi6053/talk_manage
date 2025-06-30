//  Null değer alabilen (opsiyonel) model
class PostModel {
  int? userId;
  int? id;
  String? title;
  String? body;

  // Opsiyonel constructor
  PostModel({this.userId, this.id, this.title, this.body});
}

// Sıralı constructor kullanan model (daha az önerilir)
class PostModel2 {
  final int userId;
  final int id;
  final String title;
  final String body;

  // Sıralı parametreli constructor
  PostModel2(this.userId, this.id, this.title, this.body);
}

//  En okunabilir ve güvenli hali — TAVSİYE EDİLEN!
class PostModel3 {
  final int userId;
  final int id;
  final String title;
  final String body;

  // Named (isimli) parametreli ve zorunlu (required) constructor
  PostModel3({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });
}
