import 'package:http/http.dart' as http;

class ApiNetwork {
  static const String username = 'ospivvsms@gmail.com';
  static const String password = 'ospivv2018';
  static const apiUrl =
      "portal.fastsmsnigeria.com/api/?username=$username&password=$password&action=";

  Future<http.Response> fetchData(String action) {
    return http.get(Uri.https(apiUrl, action));
  }
}
