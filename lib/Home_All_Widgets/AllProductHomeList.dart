import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Screens/Categories/productVendorSeperationPage.dart';

import '../API/HomeProductCategoriesList_API.dart';

class ALLProductCategoryHomeList extends StatefulWidget {
  final arrData;
  const ALLProductCategoryHomeList({Key? key, this.arrData}) : super(key: key);

  @override
  _ALLProductCategoryHomeListState createState() =>
      _ALLProductCategoryHomeListState();
}

class _ALLProductCategoryHomeListState
    extends State<ALLProductCategoryHomeList> {
  var arrPrdCat;
  var allCategories;
  var load = true;

  @override
  void initState() {
    super.initState();
    this.getHome();
    setState(() {});
  }

  Future<String> getHome() async {
    var response = await HomeProductCategoryAPI();
    if (response["status"].toString() == "success") {
      setState(() {
        allCategories = response["data"]["lists"];
      });
      setState(() {
        load = false;
      });
    }
    // setState(() {});
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return load == true
            ? Opacity(opacity: 0)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    height: 100,
                    alignment: Alignment.centerLeft,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 17),
                        shrinkWrap: true,
                        itemCount:
                            allCategories != null && allCategories.length <= 4
                                ? allCategories.length
                                : 4,
                        itemBuilder: (context, index) {
                          final item = allCategories != null
                              ? allCategories[index]
                              : null;
                          return AllPrdCatList(item, index);
                        })),
              );
      } else {
        return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    shrinkWrap: true,
                    itemCount:
                        allCategories != null && allCategories.length <= 6
                            ? allCategories.length
                            : 6,
                    itemBuilder: (context, index) {
                      final item = allCategories != null ? allCategories : null;
                      return AllPrdCatListTablet(item, index);
                    })));
      }
    });
  }

  AllPrdCatList(var item, int index) {
    return GestureDetector(
      onTap: () {
        // if (item["children"].length != 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => productVendorSeperationPage(
                    subCatID: item["_id"].toString())));
        // }
        // else {
        //   print("prdddddddddd");
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => catToProductListPage(
        //               data: item["_id"].toString(),
        //               title: item["name"].toString())));
        // }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           ExpandedCategory(subCatID: item["_id"].toString())),
        // );
      },
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                bottom: 5,
                left: 3,
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: prdCategoryCircleClr,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                child: Center(
                    child: Image.network(
                  productCategoryImageURL + item["image"].toString(),
                  height: 40,
                  width: 40,
                )),
              ),
            ],
          ),
          Expanded(
              child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.18,
            child: Text(item["name"].toString(),
                style: size12_700Grey,
                maxLines: 2,
                textAlign: TextAlign.center),
          ))
        ],
      ),
    );
  }

  AllPrdCatListTablet(var item, int index) {
    return Column(children: [
      Stack(
        children: [
          Positioned(
            bottom: 12,
            left: 5,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.1,
            child: Center(
                child: Image.network(
                    "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fgetdrawings.com%2Fimg%2Fsilhouette-mobile-32.png&f=1&nofb=1",
                    height: MediaQuery.of(context).size.height * 0.04,
                    fit: BoxFit.contain)),
          ),
        ],
      ),
      Expanded(
          child: Text(
        item[index]["name"].toString(),
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02),
      ))
    ]);
  }
}
