import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "https://jsonplaceholder.typicode.com";

class API {
  static Future getUsers() {
    String url = "$baseUrl/users";
    return http.get(Uri.parse(url));
  }
}
