import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:she_connect/API/ProductsListingApi.dart';
import 'package:she_connect/API/productSort_API.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/MainWidgets/shimmer.dart';
import 'package:she_connect/Screens/Filter/DATA/filterAPI.dart';
import 'package:she_connect/Screens/Filter/FilterPage.dart';

import '../Const/network.dart';
import 'Product/ProductDetailsPage.dart';

class DealsExpanded extends StatefulWidget {
  final back;
  final catID;
  DealsExpanded({Key? key, this.back, this.catID}) : super(key: key);

  @override
  _DealsExpandedState createState() => _DealsExpandedState();
}

class _DealsExpandedState extends State<DealsExpanded> {
  int _selectedIndex = 1;
  var sortValue = "Relevance";
  var arrData;
  var result;
  var load = true;
  var arrDealsList;
  var prdID;
  var idd;
  int low = 0;
  int high = 0;
  @override
  void initState() {
    super.initState();
    this.getHome();
    setState(() {});
  }

  Future<String> getHome() async {
    setState(() {
      load = true;
    });
    var rsp = await productListApi();
    if (rsp["status"].toString() == "success") {
      var catID = await getSharedPrefrence(CATID);
      var low = await getSharedPrefrence(PRICELOW);
      var high = await getSharedPrefrence(PRICEHIGH);
      var rating = await getSharedPrefrence(RATING);
      print(catID);
      print(low);
      print(high);
      print(rating);
      setState(() {
        arrDealsList = rsp["data"]["lists"];
        load = false;
      });
    }

    return "success";
  }

  Future<String> sortingCall() async {
    var rsp = await productSort_API(sortValue);
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrDealsList = rsp["data"]["lists"];
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  Future<String> filterCalltestt() async {
    setState(() {
      load = true;
    });
    var catID = await getSharedPrefrence(CATID);
    var low = await getSharedPrefrence(PRICELOW);
    var high = await getSharedPrefrence(PRICEHIGH);
    var rating = await getSharedPrefrence(RATING);
//--------------------------------------
    if (catID != null && low == null && high == null && rating == null) {
      var rsp = await onlyCatAPI(catID);
      setState(() {
        arrDealsList = rsp["data"]["lists"];
        load = false;
      });
    }
    //--------------only price------------------------
    if (catID == null && low != null && high != null && rating == null) {
      if (low == "1500") {
        var rsp = await onlyHighPrice(low);
        setState(() {
          arrDealsList = rsp["data"]["lists"];
          load = false;
        });
      } else {
        var rsp = await onlyPrice(low, high);
        setState(() {
          arrDealsList = rsp["data"]["lists"];
          load = false;
        });
      }
    }
//-------------------only rating-------------------
    if (rating != null && catID == null && low == null && high == null) {
      print("only rating");
      var rsp = await onlyRating(rating);
      setState(() {
        arrDealsList = rsp["data"]["lists"];
        load = false;
      });
    }
//------------------no rating--------------------
    if (rating == null && catID != null && low != null && high != null) {
      print("no rating");
      var rsp = await withoutRating(low, high, catID);
      setState(() {
        arrDealsList = rsp["data"]["lists"];
        load = false;
      });
    }

    //----------------"no price----------------------
    if (rating != null && catID != null && low == null && high == null) {
      print("no price");
      var rsp = await withoutPrice(rating, catID);
      setState(() {
        arrDealsList = rsp["data"]["lists"];
        load = false;
      });
    } //----------------no category----------------------
    if (rating != null && catID == null && low != null && high != null) {
      print("no category");
      var rsp = await withoutCategory(rating, low, high);
      setState(() {
        arrDealsList = rsp["data"]["lists"];
        load = false;
      });
    }

    //----------------all filter----------------------
    if (rating != null && catID != null && low != null && high != null) {
      print("all filter");
      var rsp = await allFilterAPI(rating, catID, high, low);
      setState(() {
        arrDealsList = rsp["data"]["lists"];
        load = false;
      });
    }
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Today's Deals",
          style: appBarTxtStyl,
        ),
        leading: widget.back == "no"
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 25,
                ))
            : Opacity(opacity: 0),
      ),
      body: load == true
          ? shimmerProductsGrid()
          : arrDealsList.length == 0
              ? Center(child: Text("No Products Found!", style: size12_700))
              : Scrollbar(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: RefreshIndicator(
                      onRefresh: getHome,
                      child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            arrDealsList != null ? arrDealsList.length : 0,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 0,
                            childAspectRatio: 0.59,
                            mainAxisExtent: 280),
                        itemBuilder: (BuildContext context, int index) {
                          final item =
                              arrDealsList != null ? arrDealsList : null;
                          return TdyDealGrid(item, index);
                        },
                      ),
                    ),
                  ),
                ),
      bottomNavigationBar: Container(
        height: 50,
        // height: MediaQuery.of(context).size.height * 0.08,
        color: darkPink,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _sort(),
            const VerticalDivider(
              color: Colors.white70,
            ),
            _filter(),
          ],
        ),
      ),
    );
  }

  _sort() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _sortBottom();
        },
        child: Container(
          color: darkPink,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.arrow_up_arrow_down,
                color: Colors.white,
                size: 16,
              ),
              w(5),
              const Text(
                "Sort",
                style: size14_600W,
              )
            ],
          ),
        ),
      ),
    );
  }

  _sortBottom() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0)),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 15),
                      child: Row(
                        children: [
                          const Text(
                            "Sort By",
                            style: size16_700,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              CupertinoIcons.clear_circled,
                              color: Colors.black,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio<int>(
                            value: 2,
                            toggleable: true,
                            groupValue: _selectedIndex,
                            onChanged: (value) {
                              setState(() {
                                sortValue = "-createdAt";
                                buttonValue(value!);
                                load = true;
                              });
                              sortingCall();

                              Navigator.pop(context);
                            },
                          ),
                          const Text(
                            "What’s New",
                            style: size16_400,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Radio<int>(
                            value: 4,
                            toggleable: true,
                            groupValue: _selectedIndex,
                            onChanged: (value) {
                              setState(() {
                                sortValue = "-retailPrice";
                                buttonValue(value!);
                                load = true;
                              });
                              sortingCall();

                              Navigator.pop(context);
                            },
                          ),
                          const Text(
                            "Price (Highest first)",
                            style: size16_400,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Radio<int>(
                            value: 5,
                            toggleable: true,
                            groupValue: _selectedIndex,
                            onChanged: (value) async {
                              setState(() {
                                sortValue = "retailPrice";
                                buttonValue(value!);
                                load = true;
                              });
                              // var rsp = productSort_API(sortValue);
                              // print(rsp);
                              sortingCall();
                              Navigator.pop(context);
                            },
                          ),
                          const Text(
                            "Price (Lowest first)",
                            style: size16_400,
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        top: 10),
                  ),
                ],
              ),
            ));
  }

  void buttonValue(int v) {
    setState(() {
      _selectedIndex = v;
    });
  }

  _filter() {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FilterPage(ree: filterCalltestt, reset: getHome)),
          );
          // _navigateAndDisplaySelection(context);
        },
        child: Container(
          color: darkPink,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.filter_alt,
                color: Colors.white,
                size: 16,
              ),
              w(5),
              const Text(
                "Filter",
                style: size14_600W,
              )
            ],
          ),
        ),
      ),
    );
  }

  TdyDealGrid(var item, int index) {
    return GestureDetector(
      onTap: () async {
        prdID = item[index]["_id"];
        //
        // var rsp = await productDetailsApi(prdID);
        // print(rsp);
        // arrData = rsp["data"];
        // if (rsp["status"].toString() == "success") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailsPage(pID: prdID)),
        );
        // }
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

  // _navigateAndDisplaySelection(BuildContext context) async {
  //   result = await Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => FilterPage()));
  //   var rsp = await onlyCatAPI(result.toString());
  //   if (rsp["status"].toString() == "success") {
  //     setState(() {
  //       arrDealsList = rsp["data"]["lists"];
  //     });
  //   }
  //   setState(() {
  //     load = false;
  //   });
  // }
}
