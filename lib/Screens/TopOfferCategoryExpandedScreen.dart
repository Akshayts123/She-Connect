import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:she_connect/API/productSort_API.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import 'Filter/FilterPage.dart';
import 'Product/ProductDetailsPage.dart';

class CategoryExpandedPage extends StatefulWidget {
  final titlee;
  CategoryExpandedPage({
    this.titlee,
  });

  // const CategoryExpandedPage({Key? key, required String titlee})
  //     : super(key: key);

  @override
  _CategoryExpandedPageState createState() => _CategoryExpandedPageState();
}

class _CategoryExpandedPageState extends State<CategoryExpandedPage> {
  int _selectedIndex = 1;
  var sortValue = "Relevance";

  var arrData;
  var load = true;
  var arrDealsList;
  Future<String> sortingCall() async {
    var rsp = await productSort_API(sortValue);

    if (rsp["status"].toString() == "success") {
      setState(() {
        arrDealsList = rsp["data"]["lists"];
      });
    }
    print(arrDealsList);
    setState(() {
      load = false;
    });
    print(arrDealsList);
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
              )),
        ],
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            )),
        title: Text(
          widget.titlee,
          style: appBarTxtStyl,
          maxLines: 1,
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              labelColor: const Color(0xff2F455C),
              // padding: const EdgeInsets.symmetric(horizontal: 15),
              indicator: DotIndicator(
                color: darkPink,
                distanceFromCenter: 16,
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
                  text: "All",
                ),
                Tab(
                  text: "Products",
                ),
                Tab(
                  text: "Services",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ExpandedGrid(),
                  ExpandedGrid(),
                  ExpandedGrid(),
                ],
              ),
            ),
          ],
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

  _filter() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FilterPage(ree: sortingCall, reset: sortingCall)),
          );
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

  ExpandedGrid() {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Scrollbar(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GridView.builder(
            // physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 5,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: MediaQuery.of(context).size.width * 0.5,
                mainAxisExtent: MediaQuery.of(context).size.height * 0.4
                // childAspectRatio: MediaQuery.of(context).size.width /
                //     (MediaQuery.of(context).size.height / 1.2)
                ),
            itemBuilder: (BuildContext context, int index) {
              return Item(index);
            },
          ),
        ));
      } else {
        return Scrollbar(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GridView.builder(
            // physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: MediaQuery.of(context).size.width * 0.5,
                mainAxisExtent: MediaQuery.of(context).size.height * 0.25
                // childAspectRatio: MediaQuery.of(context).size.width /
                //     (MediaQuery.of(context).size.height / 1.2)
                ),
            itemBuilder: (BuildContext context, int index) {
              return ItemTablet(index);
            },
          ),
        ));
      }
    });
  }

  Item(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductDetailsPage()),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                      image: const DecorationImage(
                          image: NetworkImage(
                            tstImg,
                          ),
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
                        borderRadius: BorderRadius.circular(10),
                        color: liteGrey),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
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
            const Text(
              "Bestima Cotton Bedsheeaa ansj abnxsjx xasxbn...",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: size12_400,
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
        ),
      ),
    );
  }

  ItemTablet(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductDetailsPage()),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                      image: const DecorationImage(
                          image: NetworkImage(
                            tstImg,
                          ),
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
                        borderRadius: BorderRadius.circular(10),
                        color: liteGrey),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
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
            const Text(
              "Bestima Cotton Bedsheeaa ansj abnxsjx xasxbn...",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: size12_400,
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
                            value: 1,
                            toggleable: true,
                            groupValue: _selectedIndex,
                            onChanged: (value) {
                              setState(() {
                                buttonValue(value!);
                                print("Relevance");
                              });
                              Navigator.pop(context);
                            },
                          ),
                          const Text(
                            "Relevance",
                            style: size16_400,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Radio<int>(
                            value: 2,
                            toggleable: true,
                            groupValue: _selectedIndex,
                            onChanged: (value) {
                              setState(() {
                                buttonValue(value!);
                                print("new");
                              });
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
                            value: 3,
                            toggleable: true,
                            groupValue: _selectedIndex,
                            onChanged: (value) {
                              setState(() {
                                buttonValue(value!);
                                print("discount");
                              });
                              Navigator.pop(context);
                            },
                          ),
                          const Text(
                            "Discount",
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
                                print("highhh");
                              });
                              sortingCall();
                              // var rsp = productSort_API(sortValue);
                              // print(rsp);
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
                                print("lowwww");
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
}
