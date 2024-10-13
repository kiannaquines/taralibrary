enum ApiResult {
  success,
  loginRequired,
  error
}

class ApiResponse<T> {
  final ApiResult result;
  final T? data;
  final String? errorMessage;

  ApiResponse({
    required this.result,
    this.data,
    this.errorMessage,
  });
}
