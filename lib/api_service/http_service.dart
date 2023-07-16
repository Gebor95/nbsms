//class HttpService {
class APIConstants {
  static const String baseUrl = "https://portal.fastsmsnigeria.com/api/";
  static const String username = "_username";
  static const String password = "_password";

  static String getApiUrl(String action) {
    return '$baseUrl?username=$username&password=$password&action=$action';
  }
}
