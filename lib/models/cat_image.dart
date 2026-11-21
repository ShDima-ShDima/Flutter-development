class CatImage {
  final String id;
  final String url;
  final int width;
  final int height;

  CatImage({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });

  factory CatImage.fromJson(Map<String, dynamic> json) {
    return CatImage(
      id: json['id'] as String,
      url: json['url'] as String,
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'width': width,
      'height': height,
    };
  }
}