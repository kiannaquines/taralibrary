class ApiSettings {
  static const String protocol = "http";
  static const String apiEndpoint = "10.0.0.101";
  static const int apiPort = 8080;
  static const String apiVersion = "/api/v1";

  static String getApiUrl() {
    return '$protocol://$apiEndpoint:$apiPort$apiVersion';
  }

  static String getStaticFileDir() {
    return '$protocol://$apiEndpoint:$apiPort';
  }
}