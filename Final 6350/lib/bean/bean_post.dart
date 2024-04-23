class PostBean {
  late String id;
  late String title;
  late double price;
  late String description;
  late String userId;
  late List<String> images;
  late int time;

  PostBean(this.id, this.title, this.price, this.description, this.userId,
      this.images, this.time);

  PostBean.fromJson(Map<String, dynamic>? json, this.id) {
    title = json?["title"] ?? "";
    price = json?["price"] ?? "";
    description = json?["description"] ?? "";
    userId = json?["userId"] ?? "";
    time = json?["time"] ?? 0;
    images = json?["images"]?.cast<String>() ?? [];
    title = json?["title"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    data['userId'] = userId;
    data['time'] = time;
    data['images'] = images;
    data['title'] = title;

    return data;
  }

  @override
  String toString() {
    return 'PostBean{id: $id, title: $title, price: $price, description: $description, userId: $userId, images: $images, time: $time}';
  }
}
