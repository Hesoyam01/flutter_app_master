import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'utils.dart';

class User {
  final int userId;
  final String username;

  User({this.userId, this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json["user_id"],
      username: json["username"],
    );
  }

  static Future<User> getUser(String username) async {
    final encodedUser = Uri.encodeQueryComponent(username);
    final res = await http.get(BACKEND_URL + "/user/" + encodedUser);

    switch (res.statusCode) {
      case 200:
        return User.fromJson(json.decode(res.body));
      case 404:
        return null;
      default:
        return handleError(res);
    }
  }

  static Future<User> createUser(String username) async {
    final encodedUser = Uri.encodeQueryComponent(username);
    final res = await http.post(BACKEND_URL + "/user/" + encodedUser);

    switch (res.statusCode) {
      case 200:
        var j = json.decode(res.body);
        return User(userId: j["user_id"], username: username);
      default:
        return handleError(res);
    }
  }
}