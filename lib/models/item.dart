class Item {
  String title;
  String description;

  Item({required this.title, required this.description});

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
  };

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'],
      description: json['description'],
    );
  }
}
