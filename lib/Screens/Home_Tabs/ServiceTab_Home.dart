// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:she_connect/API/HomePage_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Home_All_Widgets/AllServiceCatList.dart';
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

import '../ServiceCategoryExpanded.dart';

class ServiceHomeTab extends StatefulWidget {
  final data;
  final posts;
  final blogs;
  final vendors;
  const ServiceHomeTab(
      {Key? key, this.data, this.posts, this.blogs, this.vendors})
      : super(key: key);

  @override
  _ServiceHomeTabState createState() => _ServiceHomeTabState();
}

class _ServiceHomeTabState extends State<ServiceHomeTab> {
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
    var rsp = await homePageAPI("SERVICE");
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
            child: Wrap(
              runSpacing: 15,
              children: [
                const Homecarousel(),
                Top4Cat(),
                // Heading(allPrdCat, () {}),
                // ALLProductHomeList(),
                Heading(allSerCat, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ServiceCategoryExpanded(arrData: widget.data)));
                }),
                AllServiceCatList(arrData: widget.data),
                Heading(TdyDeals, () {}),
                TodaysDealHome(),
                Homecarousel_2(),
                Heading(DiwDeals, () {}),
                SplOccDeals(),
                Heading(Recc, () {}),
                RecomendedListHome(),
                Heading(TrndNw, () {}),
                TrendingNowGrid(),
                Heading(blog, () {}),
                BlogHome(blogs: widget.blogs),
                Heading(post, () {}),
                PostHome(posts: widget.posts),
                Heading(bestSllr, () {}),
                BestSellerHome(),
                Heading(sheTrst, () {}),
                SheTrusted(),
                Heading(festrdStores, () {}),
                FeaturedStores(),
                Heading(nwArrivl, () {}),
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
