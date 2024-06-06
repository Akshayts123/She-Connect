import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:she_connect/API/search_API.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Screens/Product/ProductDetailsPage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var text = "";
  var arrSearch;
  var prdID;

  @override
  void initState() {
    super.initState();
    // this.getSearch(text);
    setState(() {});
  }

  var load = true;
  Future<String> getSearch(text) async {
    var rsp = await searchAPI(text);
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrSearch = rsp["data"]["lists"]["products"];
        print(rsp);
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: liteGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: searchController,
                    autofocus: false,
                    onChanged: (text) async {
                      getSearch(text);
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                          color: darkPink,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          icon: const Icon(Icons.backspace_outlined,
                              color: darkPink, size: 18),
                        ),
                        border: InputBorder.none,
                        hintText: "Search for products and services",
                        hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: grey)),
                  ),
                ),
              ),
              w(10),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: size14_600Pink,
                ),
              )
            ],
          )),
      body: load == true
          ? Center(child: Text("search for anything"))
          : arrSearch.length < 0
              ? Opacity(opacity: 0)
              : LayoutBuilder(builder: (context, snapshot) {
                  if (snapshot.maxWidth < 600) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Scrollbar(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      arrSearch != null ? arrSearch.length : 0,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 0,
                                          childAspectRatio: 0.59,
                                          mainAxisExtent: 280),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final item =
                                        arrSearch != null ? arrSearch : null;
                                    return TdyDealGrid(item, index);
                                  },
                                ),
                              ),
                            ),
                            // const Text(
                            //   "Popular Categories",
                            //   style: size16_400,
                            // ),
                            // h(20),
                            // GridView.builder(
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   shrinkWrap: true,
                            //   itemCount: 5,
                            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            //       crossAxisCount: 4,
                            //       crossAxisSpacing: 10,
                            //       mainAxisSpacing: 10,
                            //       childAspectRatio: 3),
                            //   itemBuilder: (BuildContext context, int index) {
                            //     return SuggestionGrid(index);
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Popular Categories",
                            style: size16_400,
                          ),
                          h(20),
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 10,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 5),
                            itemBuilder: (BuildContext context, int index) {
                              return SuggestionGrid(index);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                }),
    );
  }

  SuggestionGrid(int index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: darkPink),
      ),
      child: const Text(
        "Dry Clean",
        style: size12_400Grey,
      ),
    );
  }

  SuggestionGridTablet(int index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: darkPink),
      ),
      child: const Text(
        "Dry Clean",
        style: size12_400Grey,
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
              // Positioned(
              //   bottom: 15,
              //   left: 10,
              //   child: Container(
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10), color: liteGrey),
              //     child: Padding(
              //       padding:
              //           const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              //       child: Row(
              //         children: const [
              //           Text(
              //             "4.2",
              //             style: size12_400,
              //           ),
              //           Icon(
              //             Icons.star,
              //             color: Colors.black,
              //             size: 13,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
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
              item[index]["listPrice"].toString() == "0"
                  ? Opacity(opacity: 0)
                  : Text(
                      rs + item[index]["listPrice"].toString(),
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
    );
  }
}
