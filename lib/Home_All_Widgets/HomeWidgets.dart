import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:she_connect/API/HomePage_api.dart';
import 'package:she_connect/API/ProductsListingApi.dart';
import 'package:she_connect/API/homebanner1_API.dart';
import 'package:she_connect/API/listAllVendors_API.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Home_Tabs/AllTab_Home.dart';
import 'package:she_connect/Screens/Home_Tabs/ProductsTab_Home.dart';
import 'package:she_connect/Screens/Home_Tabs/SheConnectHome.dart';
import 'package:she_connect/Screens/Product/ProductDetailsPage.dart';
import 'package:she_connect/Screens/SearchScreen.dart';

import '../API/ListAllPosts_api.dart';
import '../API/listAllBlogs_api.dart';

class HomeSearch extends StatelessWidget {
  const HomeSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: liteGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 17,
                        color: darkPink,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "Search for products and services",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  inherit: true,
                                  fontWeight: FontWeight.w400,
                                  color: grey),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: darkPink),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class HomeTabs extends StatefulWidget {
  const HomeTabs({Key? key}) : super(key: key);

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  var isLoad = true;
  var arrALL;
  var arrPRODUCT;
  var arrSERVICE;
  var arrPosts = [];
  var arrBlogs = [];
  var arrBanners1;
  var arrVendors = [];

  @override
  void initState() {
    super.initState();
    this.load();
    this.getPosts();
    this.getBlogs();
    this.getVendors();
    this.getBanners();
    setState(() {});
  }

  Future<String> loadAll() async {
    await getPosts();
    await getBlogs();
    await getVendors();
    await getBanners();
    await load();
    setState(() {
      isLoad = false;
    });
    return "success";
  }

  Future<String> load() async {
    var rsp = await homePageAPI("ALL");
    if (rsp["status"].toString() == "success") {
      arrALL = rsp["data"];
    }
    setState(() {
      isLoad = false;
    });
    return "success";
  }

  Future<String> getPosts() async {
    var rsp = await listPostsApi();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrPosts = rsp["data"]["lists"];
      });
      setState(() {});
    }
    return "success";
  }

  Future<String> getBanners() async {
    var rsp = await homeBanners1API();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrBanners1 = rsp;
      });
      setState(() {});
    }
    return "success";
  }

  Future<String> getBlogs() async {
    var rsp = await listAllBlogsAPI();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrBlogs = rsp["data"]["lists"];
      });
      print("11111111111111111111");
      print(arrBlogs);
      print("1111111111111111111");
      setState(() {});
    }
    return "success";
  }

  Future<String> getVendors() async {
    var rsp = await listVendorsAPI();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrVendors = rsp["data"]["lists"];
      });
      setState(() {});
    }
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    if (isLoad == true) {
      return Container(
          height: MediaQuery.of(context).size.height * 0.5, child: loading());
    } else {
      return DefaultTabController(
        length: 4,
        child: Expanded(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: liteGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 17,
                                    color: darkPink,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          "Search for products and services",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 15,
                                              inherit: true,
                                              fontWeight: FontWeight.w400,
                                              color: grey),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 20),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: darkPink),
                    //     child: const Padding(
                    //       padding:
                    //           EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    //       child: Icon(
                    //         Icons.menu,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TabBar(
                        labelPadding: EdgeInsets.only(right: 8),
                        isScrollable: true,
                        labelColor: darkPink,
                        enableFeedback: true,
                        unselectedLabelColor: Colors.black,
                        onTap: (index) async {
                          if (index == 0) {
                            var rsp = await homePageAPI("ALL");
                            setState(() {
                              if (rsp["status"].toString() == "success") {
                                arrALL = rsp["data"];
                              } else {
                                showToastError("Something went wrong!");
                              }
                            });
                          } else {
                            if (index == 1) {
                              var rsp = await homePageAPI("PRODUCT");
                              setState(() {
                                if (rsp["status"].toString() == "success") {
                                  arrPRODUCT = rsp["data"];
                                } else {
                                  showToastError("Something went wrong!");
                                }
                              });
                            } else {
                              if (index == 2) {
                                var rsp = await homePageAPI("SERVICE");
                                setState(() {
                                  if (rsp["status"].toString() == "success") {
                                    arrSERVICE = rsp["data"];
                                  } else {
                                    showToastError("Something went wrong!");
                                  }
                                });
                              }
                            }
                          }
                        },
                        indicatorPadding: EdgeInsets.only(top: 8),
                        indicatorColor: Colors.transparent,
                        labelStyle: const TextStyle(
                            color: darkPink,
                            fontSize: 14,
                            fontFamily: 'Segoe',
                            fontWeight: FontWeight.w700),
                        unselectedLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Segoe',
                            fontWeight: FontWeight.w400),
                        tabs: [
                          Tab(
                            child: Container(
                              width: 72,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: liteGrey),
                              child: Text("All"),
                            ),
                          ),
                          Tab(
                            child: Container(
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: liteGrey),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text("Products"),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: liteGrey),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text("Services"),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: liteGrey),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text("She Connect"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    preferredSize: Size.fromHeight(55)),
              )
            ],
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 20),
                //   child: TabBar(
                //     labelPadding: EdgeInsets.only(right: 8),
                //     isScrollable: true,
                //     labelColor: darkPink,
                //     enableFeedback: true,
                //     unselectedLabelColor: Colors.black,
                //     onTap: (index) async {
                //       if (index == 0) {
                //         var rsp = await homePageAPI("ALL");
                //         setState(() {
                //           if (rsp["status"].toString() == "success") {
                //             arrALL = rsp["data"];
                //           } else {
                //             showToastError("Something went wrong!");
                //           }
                //         });
                //       } else {
                //         if (index == 1) {
                //           var rsp = await homePageAPI("PRODUCT");
                //           setState(() {
                //             if (rsp["status"].toString() == "success") {
                //               arrPRODUCT = rsp["data"];
                //             } else {
                //               showToastError("Something went wrong!");
                //             }
                //           });
                //         } else {
                //           if (index == 2) {
                //             var rsp = await homePageAPI("SERVICE");
                //             setState(() {
                //               if (rsp["status"].toString() == "success") {
                //                 arrSERVICE = rsp["data"];
                //               } else {
                //                 showToastError("Something went wrong!");
                //               }
                //             });
                //           }
                //         }
                //       }
                //     },
                //     indicatorPadding: EdgeInsets.only(top: 8),
                //     indicatorColor: Colors.transparent,
                //     labelStyle: const TextStyle(
                //         color: darkPink,
                //         fontSize: 14,
                //         fontFamily: 'Segoe',
                //         fontWeight: FontWeight.w700),
                //     unselectedLabelStyle: const TextStyle(
                //         color: Colors.black,
                //         fontSize: 14,
                //         fontFamily: 'Segoe',
                //         fontWeight: FontWeight.w400),
                //     tabs: [
                //       Tab(
                //         child: Container(
                //           width: 72,
                //           height: 34,
                //           alignment: Alignment.center,
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(10),
                //               color: liteGrey),
                //           child: Text("All"),
                //         ),
                //       ),
                //       Tab(
                //         child: Container(
                //           height: 34,
                //           alignment: Alignment.center,
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(10),
                //               color: liteGrey),
                //           child: Padding(
                //             padding: const EdgeInsets.symmetric(horizontal: 15),
                //             child: Text("Products"),
                //           ),
                //         ),
                //       ),
                //       Tab(
                //         child: Container(
                //           height: 34,
                //           alignment: Alignment.center,
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(10),
                //               color: liteGrey),
                //           child: Padding(
                //             padding: const EdgeInsets.symmetric(horizontal: 15),
                //             child: Text("Services"),
                //           ),
                //         ),
                //       ),
                //       Tab(
                //         child: Container(
                //           height: 34,
                //           alignment: Alignment.center,
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(10),
                //               color: liteGrey),
                //           child: Padding(
                //             padding: const EdgeInsets.symmetric(horizontal: 15),
                //             child: Text("She Connect"),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // h(10),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      AllHomeTab(
                          data: arrALL,
                          banner1: arrBanners1,
                          posts: arrPosts,
                          blogs: arrBlogs,
                          vendors: arrVendors),
                      ProductsHomeTab(
                          data: arrPRODUCT,
                          posts: arrPosts,
                          blogs: arrBlogs,
                          vendors: arrVendors),
                      Container(
                          color: Color(0xfff6f6f6),
                          child: Opacity(
                            child: Image.asset(
                              "assets/Images/comingSoon.png",
                            ),
                            opacity: 0.5,
                          )),
                      // ServiceHomeTab(
                      //     data: arrSERVICE,
                      //     posts: arrPosts,
                      //     blogs: arrBlogs,
                      //     vendors: arrVendors),
                      SheConnectHome(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

class TodaysDealHome extends StatefulWidget {
  const TodaysDealHome({Key? key}) : super(key: key);

  @override
  State<TodaysDealHome> createState() => _TodaysDealHomeState();
}

class _TodaysDealHomeState extends State<TodaysDealHome> {
  var arrData;
  var load = true;
  var arrDealsList;
  var prdID;
  var base;
  @override
  void initState() {
    super.initState();
    this.getHome();
    setState(() {});
  }

  Future<String> getHome() async {
    var rsp = await productListApi();
    if (rsp["status"].toString() == "success") {
      setState(() {
        base = rsp["data"]["baseUrl"];
        arrDealsList = rsp["data"]["lists"];
      });
      ;
      setState(() {
        load = false;
      });
    }
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return load == true
        ? Opacity(opacity: 0)
        : LayoutBuilder(builder: (context, snapshot) {
            if (snapshot.maxWidth < 600) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: arrDealsList != null && arrDealsList.length <= 2
                      ? arrDealsList.length
                      : 4,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 0,
                    childAspectRatio: 0.59,
                    mainAxisExtent: 280,
                    // MediaQuery.of(context).size.height * 0.35
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final item = arrDealsList != null ? arrDealsList : null;
                    return TdyDealGrid(item, index);
                  },
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 8,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      childAspectRatio: MediaQuery.of(context).size.width * 0.5,
                      mainAxisExtent: MediaQuery.of(context).size.height * 0.25
                      // childAspectRatio: MediaQuery.of(context).size.width /
                      //     (MediaQuery.of(context).size.height / 1.2)
                      ),
                  itemBuilder: (BuildContext context, int index) {
                    return TabletTdyGrid(index);
                  },
                ),
              );
            }
          });
  }

  TdyDealGrid(var item, int index) {
    return GestureDetector(
      onTap: () async {
        prdID = item[index]["_id"];
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailsPage(pID: prdID)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 213,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: item[index]["image"] != null
                            ? NetworkImage(baseUrl +
                                catalogue +
                                item[index]["image"].toString())
                            : AssetImage("assets/Images/LogoVector.png")
                                as ImageProvider,
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
            // "Bestima Cotton Bedshee...",
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

  TabletTdyGrid(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                      image: NetworkImage(
                          "https://f1af951e8abcbc4c70b9-9997fa854afcb64e87870c0f4e867f1d.lmsin.net/1000008427268-1000008427267_01-710.jpg"),
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
            Positioned(
              bottom: 15,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: liteGrey),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Row(
                    children: const [
                      Text(
                        "4.2",
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
        const Text(
          "Bestima Cotton Bedsheeaa ansj abnxsjx xasxbn...",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: size14_700,
        ),
        Row(
          children: const [
            Text(
              rs + "399",
              style: size16_400,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              rs + "699",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.lineThrough),
            ),
          ],
        ),
      ],
    );
  }
}
