import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/MainScreens/Cart.dart';
import 'package:she_connect/Screens/WishlistScreen.dart';

class ConstructorCategories extends StatefulWidget {
  final data;
  const ConstructorCategories({Key? key, this.data}) : super(key: key);

  @override
  _ConstructorCategoriesState createState() => _ConstructorCategoriesState();
}

class _ConstructorCategoriesState extends State<ConstructorCategories> {
  var arrSubCats = [];
  var arr;
  var load = true;

  @override
  void initState() {
    super.initState();
    print(widget.data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 25)),
            title: load == true
                ? Text("Loading..", style: appBarTxtStyl)
                : Text(arr["name"].toString(), style: appBarTxtStyl),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Wishlist()),
                    );
                  },
                  icon: const Icon(Icons.favorite_border, size: 25)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Cart()),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined, size: 18))
            ]),
        body: load == true
            ? Center(
                child: SpinKitWave(
                  color: darkPink,
                  type: SpinKitWaveType.center,
                  size: 25,
                ),
              )
            : LayoutBuilder(builder: (context, snapshot) {
                if (snapshot.maxWidth < 600) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.data != null ? widget.data : 0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 0.56),
                          itemBuilder: (BuildContext context, int index) {
                            final item =
                                widget.data != null ? widget.data[index] : null;
                            return GridItem(item, index);
                          }));
                } else {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              widget.data != null ? widget.data.length : 0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 0.9),
                          itemBuilder: (BuildContext context, int index) {
                            final item =
                                widget.data != null ? widget.data[index] : null;
                            return GridItemTablet(index);
                          }));
                }
              }));
  }

  GridItem(var item, int index) {
    return GestureDetector(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const ExpandedCategory()));
        },
        child: Column(children: [
          CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.15,
              backgroundColor: liteGrey,
              child: Image.network(
                  "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fgetdrawings.com%2Fimg%2Fsilhouette-mobile-32.png&f=1&nofb=1",
                  width: MediaQuery.of(context).size.width * 0.1)),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: Text(item["name"].toString(),
                  maxLines: 2, textAlign: TextAlign.center, style: size12_400))
        ]));
  }

  GridItemTablet(int index) {
    return GestureDetector(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const ExpandedCategory()));
        },
        child: Column(children: [
          CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.05,
              backgroundColor: liteGrey,
              child: Image.network(
                  "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fgetdrawings.com%2Fimg%2Fsilhouette-mobile-32.png&f=1&nofb=1",
                  width: MediaQuery.of(context).size.width * 0.05)),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: const Text("Home Appliances",
                  maxLines: 2, textAlign: TextAlign.center, style: size12_400))
        ]));
  }
}
