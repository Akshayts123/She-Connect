import 'package:flutter/material.dart';
import 'package:she_connect/API/favouritesList_api.dart';
import 'package:she_connect/API/removeFromFav.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/MainWidgets/shimmer.dart';
import 'package:she_connect/Screens/Product/ProductDetailsPage.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  var arrList;
  var baseURL;
  var load = true;
  @override
  void initState() {
    super.initState();
    this.getFav();
    setState(() {});
  }

  Future<String> getFav() async {
    var rsp = await FavouritesListAPI();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrList = rsp["data"]["lists"];
        baseURL = rsp["data"]["baseUrl"];
        print(arrList);
        print("```````````````````````arrList```````````````````````");
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            )),
        title: const Text(
          "My Wishlist",
          style: appBarTxtStyl,
        ),
      ),
      body: load == true
          ? shimmerProductsGrid()
          : arrList.isEmpty
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/Images/emptyWishlist.png",
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    h(10),
                    Text("Your wishlist is empty!", style: size14_600)
                  ],
                ))
              : LayoutBuilder(builder: (context, snapshot) {
                  if (snapshot.maxWidth < 600) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RefreshIndicator(
                        onRefresh: getFav,
                        child: GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: arrList != null ? arrList.length : 0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 40,
                                  childAspectRatio: 0.6),
                          itemBuilder: (BuildContext context, int index) {
                            final item =
                                arrList != null ? arrList[index] : null;
                            return Item(item, index);
                          },
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: GridView.builder(
                        // physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 11,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 40,
                            childAspectRatio:
                                MediaQuery.of(context).size.width * 0.5,
                            mainAxisExtent:
                                MediaQuery.of(context).size.height * 0.25),
                        itemBuilder: (BuildContext context, int index) {
                          return TabletItem(index);
                        },
                      ),
                    );
                  }
                }),
    );
  }

  Item(var item, int index) {
    print(item);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductDetailsPage(pID: item["product"]["_id"])),
        );
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                // height: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                    image: DecorationImage(
                        image: NetworkImage(baseURL +
                            "/" +
                            item["product"]["image"].toString()),
                        fit: BoxFit.cover)),
              ),
              Positioned(
                top: 3,
                right: 3,
                child: GestureDetector(
                  onTap: () async {
                    var rsp = await removeFromFavAPI(
                        item["product"]["_id"].toString());
                    getFav();
                  },
                  child: CircleAvatar(
                      radius: 13,
                      child: Icon(Icons.close, color: Colors.black, size: 15),
                      backgroundColor: Colors.white70),
                ),
              )
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item["product"]["name"].toString(),
                  style: size14_400Grey,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              h(5),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Text(rs + item["product"]["retailPrice"].toString(),
                      style: size14_600),
                  Text(rs + item["product"]["listPrice"].toString(),
                      style: size14_400Cross),
                ],
              ),
            ]))
      ]),
    );
  }

  TabletItem(int index) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: (Colors.grey[300]!),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                // height: 160,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    border: Border.all(color: Colors.black12),
                    image: const DecorationImage(
                        image: NetworkImage(tstImg), fit: BoxFit.cover)),
              ),
            ),
            h(5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                runSpacing: 5,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Silverline Hand Bag ",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: size14_400Grey),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: const [
                      Text(rs + "45,999", style: size14_600),
                      Text(rs + "49,999", style: size14_400Cross),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: darkPink)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: [
                          Icon(Icons.shopping_cart_outlined,
                              size: 18, color: darkPink),
                          Text("MOVE TO CART", style: size14_600Pink)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
