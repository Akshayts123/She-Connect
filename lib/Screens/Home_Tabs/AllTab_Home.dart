// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Home_All_Widgets/AllProductHomeList.dart';
import 'package:she_connect/Home_All_Widgets/FeaturedStores_Home.dart';
import 'package:she_connect/Home_All_Widgets/HomeCarousel_2.dart';
import 'package:she_connect/Home_All_Widgets/HomeTopCarousel.dart';
import 'package:she_connect/Home_All_Widgets/HomeWidgets.dart';
import 'package:she_connect/Home_All_Widgets/Posts_Home.dart';
import 'package:she_connect/Home_All_Widgets/RecomendedList.dart';
import 'package:she_connect/Home_All_Widgets/SpecialOccasionDeals.dart';
import 'package:she_connect/Home_All_Widgets/Top4Categories.dart';
import 'package:she_connect/Screens/Blog/Blog_HomePage.dart';
import 'package:she_connect/Screens/DealsExpanded.dart';

import '../Blog/BlogsListScreen.dart';
import '../Categories/ProductCategoryExpanded.dart';
import '../Posts/ViewAllPostsScreen.dart';
import '../TopOfferCategoryExpandedScreen.dart';
import '../Vendor/Tabs/FeaturedStoresGrid.dart';

class AllHomeTab extends StatefulWidget {
  final data;
  final posts;
  final blogs;
  final vendors;
  final banner1;
  const AllHomeTab({
    Key? key,
    this.data,
    this.posts,
    this.blogs,
    this.vendors,
    this.banner1,
  }) : super(key: key);

  @override
  _AllHomeTabState createState() => _AllHomeTabState();
}

class _AllHomeTabState extends State<AllHomeTab> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Homecarousel(data: widget.banner1),
      h(10),
      Top4Cat(),
      h(30),
      Heading(allPrdCat, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductCategoryExpanded(arrData: widget.data)));
      }),
      h(15),
      ALLProductCategoryHomeList(),
      h(30),
      // Heading(allSerCat, () {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) =>
      //               ServiceCategoryExpanded(arrData: widget.data)));
      // }),
      // h(20),
      // AllServiceCatList(arrData: widget.data),
      // h(40),
      Heading(TdyDeals, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DealsExpanded(back: "no")),
        );
      }),
      h(15),
      const TodaysDealHome(),
      h(30),
      const Homecarousel_2(),
      Container(
        height: 30,
        color: bgLiteHilightColor,
        width: double.infinity,
      ),
      Container(child: Heading(DiwDeals, () {}), color: bgLiteHilightColor),
      Container(
        height: 15,
        color: bgLiteHilightColor,
        width: double.infinity,
      ),
      SplOccDeals(data: widget.data),
      Container(
        height: 15,
        color: bgLiteHilightColor,
        width: double.infinity,
      ),
      h(15),
      Heading(Recc, () {}),
      h(15),
      const RecomendedListHome(),
      h(30),
      Heading(TrndNw, () {}),
      h(15),
      const TodaysDealHome(),

      // TrendingNowGrid(),
      h(20),
      Heading(blog, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BlogsScreen()),
        );
      }),
      h(15),
      BlogHome(blogs: widget.blogs),
      h(30),
      widget.posts.length == 0
          ? Opacity(opacity: 0)
          : Container(
              color: Colors.black,
              child: Column(
                children: [
                  widget.posts.length == 0
                      ? Opacity(opacity: 0)
                      : Container(
                          color: Colors.black,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              child: Row(children: [
                                Text("Post", style: size16_700W),
                                const Spacer(),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AllPostsScreen()),
                                      );
                                    },
                                    child: const Text("View All",
                                        style: size12_400W))
                              ])),
                          // child: Heading(post, () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => const AllPostsScreen()),
                          //   );
                          // }),
                        ),
                  widget.posts.length == 0
                      ? Opacity(opacity: 0)
                      : Container(
                          height: 15,
                          color: Colors.black,
                        ),
                  widget.posts.length == 0
                      ? Opacity(opacity: 0)
                      : Container(
                          child: PostHome(posts: widget.posts),
                          color: Colors.black),
                  widget.posts.length == 0
                      ? Opacity(opacity: 0)
                      : Container(
                          height: 30,
                          color: Colors.black,
                        ),
                ],
              ),
            ),
      widget.posts.length == 0 ? Opacity(opacity: 0) : h(30),

      Heading(bestSllr, () {}),
      h(15),
      const TodaysDealHome(),

      // const BestSellerHome(),
      h(30),
      Heading(sheTrst, () {}),
      h(15),
      const TodaysDealHome(),

      // const SheTrusted(),
      h(30),
      Heading(festrdStores, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const FeaturedStoresScreen()));
      }),
      h(15),
      FeaturedStores(vendors: widget.vendors),
      h(30),
      Heading(nwArrivl, () {}),
      h(15),
      const TodaysDealHome(),

      // const NewArrival()
    ]));
  }

  Widget Heading(String HeadTxt, GestureTapCallback onTapp) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          Text(HeadTxt, style: size16_700),
          const Spacer(),
          GestureDetector(
              onTap: () {
                onTapp();
              },
              child: const Text("View All", style: size12_400))
        ]));
  }

  Widget _catCircle(String HeadTxt) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryExpandedPage(titlee: HeadTxt)));
        },
        child: Container(
            height: MediaQuery.of(context).size.height * 0.13,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Text(HeadTxt,
                        style: TextStyle(
                            color: darkPink,
                            fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontFamily: 'Segoe'),
                        maxLines: 2,
                        textAlign: TextAlign.center))),
            decoration: BoxDecoration(
                color: liteGrey,
                border: Border.all(
                  color: darkPink,
                ),
                shape: BoxShape.circle)));
  }
}
