import 'package:flutter/material.dart';
import '../backend/backend.dart';

// ignore: must_be_immutable
class AddCard extends StatefulWidget {
  AddCard(this.name, this.desc, this.category, this.amount);

  String name;
  String desc;
  String category;
  int amount;

  @override
  _AddCardState createState() => _AddCardState(name, desc, category, amount);
}

class _AddCardState extends State<AddCard> {
  _AddCardState(this.name, this.desc, this.category, this.amount);

  String name;
  String desc;
  String category;
  int amount;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Image.asset(
            "lib/assets/images/item.png",
            fit: BoxFit.cover,
          ),
          title: Text(name),
          subtitle: Text(desc),
        ),
        ButtonBar(
          children: <Widget>[
            Text(amount.toString()),
            Text(category),
            FlatButton(
                onPressed: () {
                  _createItemPopupWindow(context);
                },
                child: Text(
                  "Mehr anzeigen",
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        )
      ],
    ));
  }

  void _createItemPopupWindow(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(20), child: Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),
                    Padding(padding: EdgeInsets.only(left: 20, top: 10), child: Text("Description:", style: TextStyle(fontSize: 18),),),
                    Padding(padding: EdgeInsets.only(left: 20, top: 10), child: Text("Category:", style: TextStyle(fontSize: 18),),),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(child: Padding(padding: EdgeInsets.all(20), child: Text("", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),),
                    Container(width: MediaQuery.of(context).size.width * .5, child: Padding(padding: EdgeInsets.only(left: 20, top: 10), child: Text(desc, style: TextStyle(fontSize: 18), overflow: TextOverflow.fade,),),),
                    Flexible(child: Padding(padding: EdgeInsets.only(left: 20, top: 10), child: Text(category, style: TextStyle(fontSize: 18),),),),
                  ],
                )
              ],
            )
          );
        });
  }
}

class MainScreen extends StatelessWidget {
  // The cardcoded user for testing purposes
  final _user = User(userId: 13, username: "Usernamea");

  Future<List<AddCard>> _getItems() async {
    final items = await Item.getItemsOfUser(_user);
    items.sort((a, b) =>
        a.itemId.compareTo(b.itemId)); // Sort data by ascending item id

    final categories =
        await _fetchCategories(items.map((e) => e.categoryId).toList());

    final dataWidgets = items.map((e) {
      return AddCard(
          e.name, e.description, categories[e.categoryId].name, e.quantity);
    }).toList();
    return dataWidgets;
  }

  Future<Map<int, Category>> _fetchCategories(List<int> categoryIds) async {
    Map<int, Category> categories = {};
    final toFetch = categoryIds.toSet(); // Filter duplicates by using a set

    await Future.forEach(toFetch, (catId) async {
      final cat = await Category.getCategory(catId);
      categories[catId] = cat;
    });

    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          title: Row(
            children: <Widget>[
              const Icon(
                Icons.book,
                color: Colors.black,
              ),
              const Text("  InvMaster", style: TextStyle(color: Colors.black))
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.book), title: Text("Inv")),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_add), title: Text("Add"))
        ],
      ),
      body: Container(
          child: FutureBuilder<List<AddCard>>(
        future: _getItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Future has resolved and data is ready
            return ListView(
              children: snapshot.data,
            );
          } else if (snapshot.hasError) {
            // An error occured, show it to the user
            return Text(snapshot.error.toString());
          }

          // The data is still being loaded, just show a spinner for now
          return Center(child: CircularProgressIndicator());
        },
      )),
    );
  }
}
