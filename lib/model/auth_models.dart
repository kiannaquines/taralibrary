class RegisterModel {
  final String username;
  final String emailAddress;
  final String password;
  final String confirmPassword;

  RegisterModel({
    required this.username,
    required this.emailAddress,
    required this.password,
    required this.confirmPassword,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      username: json['username'],
      emailAddress: json['emailAddress'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'emailAddress': emailAddress,
      'password': password,
      'confirmPassword': confirmPassword,
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
