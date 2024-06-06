// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:she_connect/API/HomePage_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Home_All_Widgets/AllProductHomeList.dart';
import 'package:she_connect/Home_All_Widgets/BestSeller_Home.dart';
import 'package:she_connect/Home_All_Widgets/FeaturedStores_Home.dart';
import 'package:she_connect/Home_All_Widgets/HomeCarousel_2.dart';
import 'package:she_connect/Home_All_Widgets/HomeTopCarousel.dart';
import 'package:she_connect/Home_All_Widgets/HomeWidgets.dart';
import 'package:she_connect/Home_All_Widgets/NewArrival_Home.dart';
import 'package:she_connect/Home_All_Widgets/Posts_Home.dart';
import 'package:she_connect/Home_All_Widgets/RecomendedList.dart';
import 'package:she_connect/Home_All_Widgets/SheTrusted_Home.dart';
import 'package:she_connect/Home_All_Widgets/SpecialOccasionDeals.dart';
import 'package:she_connect/Home_All_Widgets/Top4Categories.dart';
import 'package:she_connect/Home_All_Widgets/TrendingNowGrid.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Blog/Blog_HomePage.dart';
import 'package:she_connect/Screens/Blog/BlogsListScreen.dart';
import 'package:she_connect/Screens/Posts/ViewAllPostsScreen.dart';
import 'package:she_connect/Screens/Vendor/Tabs/FeaturedStoresGrid.dart';

import '../Categories/ProductCategoryExpanded.dart';

class ProductsHomeTab extends StatefulWidget {
  final data;
  final posts;
  final blogs;
  final vendors;
  const ProductsHomeTab(
      {Key? key, this.data, this.posts, this.blogs, this.vendors})
      : super(key: key);

  @override
  _ProductsHomeTabState createState() => _ProductsHomeTabState();
}

class _ProductsHomeTabState extends State<ProductsHomeTab> {
  var isLoad = true;
  var arrALL;
  @override
  void initState() {
    super.initState();
    this.load();
    setState(() {
      // isLoad = false;
    });
  }

  void load() async {
    var rsp = await homePageAPI("PRODUCT");
    if (rsp["status"].toString() == "success") {
      arrALL = rsp["data"];
    }
    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoad == true
        ? Center(child: loading())
        : SingleChildScrollView(
            child: Column(
              children: [
                const Homecarousel(),
                h(25),
                Top4Cat(),
                h(40),
                Heading(allPrdCat, () {
                  print("aaaaaaaaaa");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductCategoryExpanded(arrData: widget.data)));
                }),
                h(20),
                ALLProductCategoryHomeList(arrData: widget.data),
                h(40),
                Heading(TdyDeals, () {}),
                h(20),
                TodaysDealHome(),
                h(40),
                Homecarousel_2(),
                Container(
                  height: 30,
                  color: bgLiteHilightColor,
                  width: double.infinity,
                ),
                Container(
                    child: Heading(DiwDeals, () {}), color: bgLiteHilightColor),
                Container(
                  height: 20,
                  color: bgLiteHilightColor,
                  width: double.infinity,
                ),
                SplOccDeals(),
                Container(
                  height: 20,
                  color: bgLiteHilightColor,
                  width: double.infinity,
                ),
                h(20),
                Heading(Recc, () {}),
                h(20),
                RecomendedListHome(),
                h(40),
                Heading(TrndNw, () {}),
                h(20),
                TrendingNowGrid(),
                h(40),
                Heading(blog, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BlogsScreen()),
                  );
                }),
                h(20),
                BlogHome(blogs: widget.blogs),
                h(40),
                Heading(post, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllPostsScreen()),
                  );
                }),
                h(20),
                PostHome(posts: widget.posts),
                h(40),
                Heading(bestSllr, () {}),
                h(20),
                BestSellerHome(),
                h(40),
                Heading(sheTrst, () {}),
                h(20),
                SheTrusted(),
                h(40),
                Heading(festrdStores, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FeaturedStoresScreen()));
                }),
                h(20),
                FeaturedStores(),
                h(40),
                Heading(nwArrivl, () {}),
                h(20),
                NewArrival()
              ],
            ),
          );
  }

  Widget Heading(String txt, GestureTapCallback onTapp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(
            txt,
            style: size16_700,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              onTapp();
            },
            child: const Text(
              "View All",
              style: size12_400,
            ),
          ),
        ],
      ),
    );
  }

  AllServicList(int index) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.13,
          width: MediaQuery.of(context).size.width * 0.2,
          child: Center(
            child: Image.network(
              "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.shareicon.net%2Fdata%2F2015%2F10%2F17%2F657543_delivery_512x512.png&f=1&nofb=1",
              height: 35,
              fit: BoxFit.contain,
            ),
          ),
          decoration: BoxDecoration(color: liteGrey, shape: BoxShape.circle),
        ),
        const Expanded(
          child: Text(
            "Courier",
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  AllPrdList(
    int index,
  ) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.13,
          width: MediaQuery.of(context).size.width * 0.2,
          child: Center(
            child: Image.network(
              "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fgetdrawings.com%2Fimg%2Fsilhouette-mobile-32.png&f=1&nofb=1",
              height: 35,
              fit: BoxFit.contain,
            ),
          ),
          decoration: BoxDecoration(color: liteGrey, shape: BoxShape.circle),
        ),
        const Expanded(
          child: Text(
            "Mobile \n Phones",
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget _catCircle(String txt) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.13,
      width: MediaQuery.of(context).size.width * 0.2,
      child: Center(
        child: Text(
          txt,
          style: size14_700,
          textAlign: TextAlign.center,
        ),
      ),
      decoration: BoxDecoration(
          color: liteGrey,
          border: Border.all(
            color: darkPink,
          ),
          shape: BoxShape.circle),
    );
  }
}
