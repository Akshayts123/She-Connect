import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/MainWidgets/shimmer.dart';
import 'package:she_connect/Screens/Categories/catToProductList.dart';
import 'package:she_connect/Screens/Categories/productVendorSeperationPage.dart';

import '../../API/HomeProductCategoriesList_API.dart';
import '../../Const/network.dart';

class ProductCategoryExpanded extends StatefulWidget {
  final arrData;
  ProductCategoryExpanded({this.arrData});
  // const ProductCategoryExpanded({Key? key}) : super(key: key);

  @override
  _ProductCategoryExpandedState createState() =>
      _ProductCategoryExpandedState();
}

class _ProductCategoryExpandedState extends State<ProductCategoryExpanded> {
  var arrPrdCat;
  var allCategories = [];
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            )),
        title: Text(
          "All in Product Categories",
          style: appBarTxtStyl,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border,
                size: 25,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 25,
              )),
        ],
      ),
      body: load == true
          ? shimmerProductCategoryGrid()
          : LayoutBuilder(builder: (context, snapshot) {
              if (snapshot.maxWidth < 600) {
                return Scrollbar(
                  interactive: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 5,
                              childAspectRatio: 0.52),
                      itemCount:
                          allCategories != null ? allCategories.length : 0,
                      itemBuilder: (BuildContext context, int index) {
                        final item =
                            allCategories != null ? allCategories : null;

                        return GridItem(item, index);
                      },
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: allCategories != null ? allCategories.length : 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final item =
                          allCategories != null ? allCategories[index] : null;

                      return GridItem(item, index);
                    },
                  ),
                );
              }
            }),
    );
  }

  GridItem(var item, int index) {
    return GestureDetector(
      onTap: () {
        if (item[index]["children"].length != 0) {
          print("case 1");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => productVendorSeperationPage(
                      subCatID: item[index]["_id"].toString())));
        } else {
          print("case 2");

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => catToProductListPage(
                      data: item[index]["_id"].toString())));
        }
      },
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                bottom: 8,
                left: 4,
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: prdCategoryCircleClr,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Center(
                    child: Image.network(
                  productCategoryImageURL + item[index]["image"].toString(),
                  height: 40,
                  width: 40,
                )),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            child: Text(
              item[index]["name"].toString(),
              maxLines: 2,
              textAlign: TextAlign.center,
              style: size12_400,
            ),
          )
        ],
      ),
    );
  }
}
