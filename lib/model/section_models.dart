class AllSectionModel {
  final int zoneID;
  final String image;
  final String title;
  final String description;
  final double rating;

  AllSectionModel({
    required this.zoneID,
    required this.image,
    required this.title,
    required this.description,
    required this.rating,
  });

  factory AllSectionModel.fromJson(Map<String, dynamic> json) {
    return AllSectionModel(
      zoneID: json['section_id'],
      image: json['image_url'],
      title: json['section_name'],
      description: json['description'],
      rating: (json['total_rating']).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section_id': zoneID,
      'image_url': image,
      'section_name': title,
      'description': description,
      'total_rating': rating,
    };
  }
}