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

class ProfileModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String? profile;

  ProfileModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profile,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      profile: json['profile_img'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'profile_img': profile,
    };
  }
}



class UpdateProfileModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;

  UpdateProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }
}
