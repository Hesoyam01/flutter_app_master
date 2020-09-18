import 'package:http/http.dart' as http;

const BACKEND_URL = "https://invmaster.dani09.de";

dynamic handleError(http.Response res) {
  if (res.statusCode >= 500 || res.statusCode < 600) {
    throw Exception("Backend error: " + res.body);
  }
}