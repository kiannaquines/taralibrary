class RecentViewedSectionModel {
  final String image;
  final String title;

  RecentViewedSectionModel({
    required this.image,
    required this.title,
  });

  factory RecentViewedSectionModel.fromJson(Map<String, dynamic> json) {
    return RecentViewedSectionModel(
      image: json['image'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
    };
  }
}

class TrendingModel {
  final String image;
  final String title;

  TrendingModel({
    required this.image,
    required this.title,
  });

  factory TrendingModel.fromJson(Map<String, dynamic> json) {
    return TrendingModel(
      image: json['image'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
    };
  }
}

class EditProfileModel {
  final String username;
  final String firstName;
  final String lastName;
  final String email;

  EditProfileModel({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory EditProfileModel.formJson(Map<String, dynamic> json) {
    return EditProfileModel(
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }
}
