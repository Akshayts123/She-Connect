import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:she_connect/API/productDetialsApi.dart';
import 'package:she_connect/API/viewFullCatProducts_API.dart';
import 'package:she_connect/API/viewSubCatsUnderCategory_API.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/MainWidgets/shimmer.dart';
import 'package:she_connect/Screens/Categories/productsTab.dart';
import 'package:she_connect/Screens/Categories/vendorsTab.dart';
import 'package:she_connect/Screens/Product/ProductDetailsPage.dart';
import 'package:she_connect/Screens/WishlistScreen.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class productVendorSeperationPage extends StatefulWidget {
  final subCatID;

  const productVendorSeperationPage({Key? key, this.subCatID})
      : super(key: key);

  @override
  _productVendorSeperationPageState createState() =>
      _productVendorSeperationPageState();
}

class _productVendorSeperationPageState
    extends State<productVendorSeperationPage> {
  var arrSubCats = [];
  var arr;
  var newID;
  var arrData;
  var subbb;
  var response;
  var load = true;
  var subID;
  var tap = false;
  var selected;
  @override
  void initState() {
    super.initState();
    this.getSubCats();
    setState(() {});
  }

  Future<String> getSubCats() async {
    await getProducts();
    var response = await subCatUnderCatsAPI(widget.subCatID);
    if (response["status"].toString() == "success") {
      setState(() {
        arrSubCats = response["data"]["children"];
        arr = response["data"];
        print(arrSubCats);
      });
      setState(() {
        load = false;
      });
    }
    return "success";
  }

  Future<String> getProducts() async {
    tap == true
        ? response = await viewFullProductsAPI(newID)
        : response = await viewFullProductsAPI(widget.subCatID);
    if (response["status"].toString() == "success") {
      setState(() {
        arrData = response["data"]["lists"];
      });
      setState(() {
        // load = false;
      });
    }
    return "success";
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
            ]),
        body: load == true
            ? Center(
                child: SpinKitThreeBounce(
                  color: darkPink,
                  size: 25,
                ),
              )
            : arrSubCats.length == 0
                ? Center(child: Text("NO PRODUCTS"))
                : LayoutBuilder(builder: (context, snapshot) {
                    if (snapshot.maxWidth < 600) {
                      return DefaultTabController(
                        length: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SizedBox(
                                height: 130,
                                child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(width: 5),
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: arrSubCats != null
                                        ? arrSubCats.length
                                        : 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final item = arrSubCats != null
                                          ? arrSubCats[index]
                                          : null;
                                      return horizontalList(item, index);
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 35,
                              child: TabBar(
                                indicatorSize: TabBarIndicatorSize.label,
                                labelColor: const Color(0xff2F455C),
                                indicator: DotIndicator(
                                  color: darkPink,
                                  distanceFromCenter: 15,
                                  radius: 3,
                                  paintingStyle: PaintingStyle.fill,
                                ),
                                labelStyle: const TextStyle(
                                    color: darkPink,
                                    fontSize: 15,
                                    fontFamily: 'Segoe',
                                    fontWeight: FontWeight.w900),
                                unselectedLabelStyle: const TextStyle(
                                    color: Color(0xff141215),
                                    fontSize: 13,
                                    fontFamily: 'Segoe',
                                    fontWeight: FontWeight.w500),
                                tabs: const [
                                  Tab(
                                    text: "Products",
                                  ),
                                  Tab(
                                    text: "Vendors",
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: TabBarView(children: [
                              // tap == true
                              //     ? catToProductListPage(arrData: arrData)
                              //     :
                              tap == true
                                  ? Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: load == true
                                            ? shimmerProductsGrid()
                                            : Scrollbar(
                                                child: RefreshIndicator(
                                                  onRefresh: getSubCats,
                                                  child: arrData.length == 0
                                                      ? Center(
                                                          child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Image.asset(
                                                                "assets/noItem.png",
                                                                height: 150),
                                                            h(15),
                                                            Text("No Items",
                                                                style:
                                                                    size14_400Grey),
                                                          ],
                                                        ))
                                                      : GridView.builder(
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          shrinkWrap: true,
                                                          // itemCount: 5,
                                                          itemCount: arrData !=
                                                                  null
                                                              ? arrData.length
                                                              : 0,
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            crossAxisSpacing:
                                                                10,
                                                            mainAxisSpacing: 0,
                                                            childAspectRatio:
                                                                0.59,
                                                            mainAxisExtent: 270,
                                                            // childAspectRatio: MediaQuery.of(context).size.width /
                                                            //     (MediaQuery.of(context).size.height / 1.2)
                                                          ),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            final item =
                                                                arrData != null
                                                                    ? arrData
                                                                    : null;
                                                            return TdyDealGrid(
                                                                item, index);
                                                          },
                                                        ),
                                                ),
                                              ),
                                      ),
                                    )
                                  // ? productsTabNewLoad(id: newID.toString())
                                  // ? productsTab(id: newID.toString())
                                  : productsTab(id: widget.subCatID),
                              vendorsTab(id: widget.subCatID)
                            ]))
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  arrSubCats != null ? arrSubCats.length : 0,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 0.9),
                              itemBuilder: (BuildContext context, int index) {
                                final item = arrSubCats != null
                                    ? arrSubCats[index]
                                    : null;
                                return GridItemTablet(index);
                              }));
                    }
                  }));
  }

  horizontalList(var item, int index) {
    return GestureDetector(
        onTap: () async {
          setState(() {
            tap = true;
            selected = index;
            newID = item["_id"].toString();
            getProducts();
          });
          // var rsp = await catToProductListAPI(item["_id"].toString());
          // if (rsp["status"].toString() == "success") {
          //   setState(() {
          //     arrData = rsp["data"]["lists"];
          //   });
          // }
          // setState(() {
          //
          //   // tap = true;
          //   // subbb = item["_id"];
          // });

          // print(item["_id"]);
          // if (item["children"].length != 0) {
          //   print("to category");
          //
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               ConstructorCategories(data: item["children"])));
          // } else {

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => catToProductListPage(
          //           data: item["_id"], title: item["name"].toString())),
          // );

          // }
        },
        child: Column(children: [
          Stack(
            children: [
              Positioned(
                bottom: 8,
                left: 4,
                child: CircleAvatar(
                    radius: 17, backgroundColor: prdCategoryCircleClr),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Center(
                      child: Image.network(
                          productCategoryImageURL + item["image"].toString(),
                          height: 40,
                          width: 40))),
            ],
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Text(item["name"].toString(),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: selected == index ? size14_600 : size12_400))
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

  TdyDealGrid(var item, int index) {
    return GestureDetector(
      onTap: () async {
        var prdID = item[index]["_id"];

        var rsp = await productDetailsApi(prdID);
        print(rsp);
        arrData = rsp["data"];
        if (rsp["status"].toString() == "success") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsPage(pID: prdID)),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 213,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(baseUrl +
                            catalogue +
                            item[index]["image"].toString()),
                        fit: BoxFit.cover)),
              ),
              // const Positioned(
              //   bottom: 15,
              //   right: 10,
              //   child: Icon(
              //     Icons.favorite,
              //     color: Colors.white,
              //   ),
              // ),
              item[index]["avgRating"].toString() == "0"
                  ? Opacity(opacity: 0)
                  : Positioned(
                      bottom: 15,
                      left: 10,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: liteGrey),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: Row(
                            children: [
                              Text(
                                item[index]["avgRating"].toString(),
                                style: size12_400,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.black,
                                size: 13,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          h(8),
          Text(
            item[index]["name"].toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: size14_400,
          ),
          Row(
            children: [
              Text(
                rs + item[index]["retailPrice"].toString(),
                style: size16_400,
              ),
              SizedBox(
                width: 10,
              ),
              item[index]["listPrice"].toString() != "0"
                  ? Text(
                      rs + item[index]["listPrice"].toString(),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.lineThrough),
                    )
                  : Opacity(opacity: 0),
            ],
          ),
        ],
      ),
    );
  }
}
