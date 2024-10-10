class RegisterModel {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;

  RegisterModel({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}

class Login {
  final String username;
  final String password;

  Login({
    required this.username,
    required this.password,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class LoginResponse {
  final String token;
  final String type;

  LoginResponse({
    required this.token,
    required this.type,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'type': type,
    };
  }
}

class AccountVerification {
  final String code;
  final int userId;

  AccountVerification({
    required this.code,
    required this.userId,
  });

  factory AccountVerification.fromJson(Map<String, dynamic> json) {
    return AccountVerification(
      code: json['code'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'user_id': userId,
    };
  }
}
