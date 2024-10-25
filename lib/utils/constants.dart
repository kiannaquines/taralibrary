class ApiSettings {
  static const String protocol = "http";
  static const String apiEndpoint = "10.0.0.169";
  static const int apiPort = 5002;
  static const String apiVersion = "/api/v1";

  static String getApiUrl() {
    return '$protocol://$apiEndpoint:$apiPort$apiVersion';
  }

  static String getStaticFileDir() {
    return '$protocol://$apiEndpoint:$apiPort';
  }
}