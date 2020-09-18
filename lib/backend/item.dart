import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'utils.dart';
import 'user.dart';
import 'category.dart';

class Item {
  final String name;
  final String description;
  final int quantity;
  final int categoryId;
  final int userId;
  final int itemId;

  Item(
      {this.name,
      this.description,
      this.quantity,
      this.userId,
      this.itemId,
      this.categoryId});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json["name"],
      description: json["description"],
      quantity: json["quantity"],
      categoryId: json["category_id"],
      userId: json["user_id"],
      itemId: json["item_id"],
    );
  }

  static Future<List<Item>> getItemsOfUser(User user) async {
    final res =
        await http.get(BACKEND_URL + "/items/" + user.userId.toString());

    switch (res.statusCode) {
      case 200:
        List<dynamic> jList = json.decode(res.body);
        return jList.map((j) => Item.fromJson(j)).toList();
      default:
        return handleError(res);
    }
  }

  static Future<Item> createItem(String name, String description, int quantity,
      Category category, User user) async {
    final res = await http
        .post(BACKEND_URL + "/items/" + user.userId.toString(), body: {
      "name": name,
      "description": description,
      "quantity": quantity,
      "category_id": category.categoryId,
    });

    switch (res.statusCode) {
      case 200:
        final j = json.decode(res.body);
        return Item(
          name: name,
          description: description,
          quantity: quantity,
          categoryId: category.categoryId,
          userId: user.userId,
          itemId: j["item_id"],
        );
      default:
        return handleError(res);
    }
  }

  static Future<Item> getItem(int itemId) async {
    final res = await http.get(BACKEND_URL + "/item/" + itemId.toString());

    switch (res.statusCode) {
      case 200:
        return Item.fromJson(json.decode(res.body));
      case 400:
        return null;
      default:
        return handleError(res);
    }
  }

  Future<bool> deleteItem() async {
    final res = await http.delete(BACKEND_URL + "/item/" + itemId.toString());

    switch (res.statusCode) {
      case 200:
        return json.decode(res.body)["success"];
      default:
        return handleError(res);
    }
  }
}
