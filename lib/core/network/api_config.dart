/// Runtime configuration for the HTTP layer.
///
/// Provide the URL per environment instead of committing it to source control:
/// `flutter run --dart-define=API_BASE_URL=https://api.example.com`
abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment('API_BASE_URL');
  static bool get hasBaseUrl => baseUrl.trim().isNotEmpty;
  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
