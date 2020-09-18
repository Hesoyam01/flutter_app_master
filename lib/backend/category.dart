import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'utils.dart';
import 'user.dart';

class Category {
  final String name;
  final String description;
  final int userId;
  final int categoryId;

  Category({this.name, this.description, this.userId, this.categoryId});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      userId: json["user_id"],
      categoryId: json["category_id"],
      name: json["name"],
      description: json["description"],
    );
  }

  static Future<List<Category>> getCategoriesOfUser(User user) async {
    final res =
        await http.get(BACKEND_URL + "/categories/" + user.userId.toString());

    switch (res.statusCode) {
      case 200:
        List<dynamic> jList = json.decode(res.body);
        return jList.map((j) => Category.fromJson(j)).toList();
      default:
        return handleError(res);
    }
  }

  static Future<Category> createCategory(
      User user, String name, String description) async {
    final res =
        await http.post(BACKEND_URL + "/categories/" + user.userId.toString());

    switch (res.statusCode) {
      case 200:
        var j = json.decode(res.body);
        return Category(
            name: name,
            description: description,
            userId: user.userId,
            categoryId: j["id"]);
      default:
        return handleError(res);
    }
  }

  static Future<Category> getCategory(int categoryId) async {
    final res =
        await http.get(BACKEND_URL + "/category/" + categoryId.toString());

    switch (res.statusCode) {
      case 200:
        return Category.fromJson(json.decode(res.body));
      case 400:
        return null;
      default:
        return handleError(res);
    }
  }

  Future<bool> deleteCategory() async {
    final res = await http
        .delete(BACKEND_URL + "/category/" + this.categoryId.toString());

    switch (res.statusCode) {
      case 200:
        return json.decode(res.body)["success"];
      default:
        return handleError(res);
    }
  }
}