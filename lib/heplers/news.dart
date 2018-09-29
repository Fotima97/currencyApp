class News {
  final String description;
  final String title;
  final String fieldImage;

  News({this.description, this.title, this.fieldImage});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        description: json['description'] as String,
        title: json['title'] as String,
        fieldImage: json['field_image'] as String);
  }
}
