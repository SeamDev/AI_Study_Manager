class NoticeLink {
  final String label;
  final String link;

  NoticeLink({required this.label, required this.link});

  factory NoticeLink.fromJson(Map<String, dynamic> json) {
    return NoticeLink(label: json['label'] ?? '', link: json['link'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'link': link};
  }
}

class NoticeModel {
  final int id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final List<NoticeLink> links;
  final DateTime createdAt;

  NoticeModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrls = const [],
    this.links = const [],
    required this.createdAt,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',

      // Keep images
      imageUrls: json['image_urls'] != null
          ? List<String>.from(json['image_urls'])
          : [],

      // Multiple labeled links
      links: json['links'] != null
          ? (json['links'] as List).map((e) => NoticeLink.fromJson(e)).toList()
          : [],

      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_urls': imageUrls,
      'links': links.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
