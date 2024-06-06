import 'package:banner_carousel/banner_carousel.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:she_connect/API/homeBanner2_API.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/network.dart';

class Homecarousel_2 extends StatefulWidget {
  const Homecarousel_2({Key? key}) : super(key: key);

  @override
  State<Homecarousel_2> createState() => _Homecarousel_2State();
}

class _Homecarousel_2State extends State<Homecarousel_2> {
  var arrData;
  var arrImages = [];
  @override
  void initState() {
    super.initState();
    this.getBanners();
    setState(() {});
  }

  Future<String> getBanners() async {
    var rsp = await homeBanners2API();
    if (rsp["status"].toString() == "success") {
      arrData = rsp["data"];
      List<dynamic> ImageData = arrData["lists"];
      if (ImageData.length != 0) {
        for (var value in ImageData) {
          final image = value["image"];
          arrImages.add(NetworkImage(productImage + image));
        }
      } else {
        print(null);
      }
      setState(() {});
    }
    return "success";
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Container(
          height: 240,
          color: bgLiteHilightColor,
          child: Carousel(
            images: arrImages,
            dotSize: 4.0,
            defaultImage: Image.asset("assets/Images/LogoVector.png"),
            dotSpacing: 10,
            dotColor: liteGrey,
            radius: const Radius.circular(0),
            dotIncreasedColor: darkPink,
            indicatorBgPadding: 5,
            dotBgColor: Colors.black12.withOpacity(0.1),
            borderRadius: true,
            // dotPosition: DotPosition.,
            autoplay: true, moveIndicatorFromBottom: 20,
          ),
        );
      } else {
        return Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                // Expanded(
                //   child: CarouselSlider(
                //     options: CarouselOptions(
                //       aspectRatio: 3.5,
                //       onPageChanged: (index, reason) {
                //         setState(() {
                //           _current = index;
                //         });
                //       },
                //       enlargeCenterPage: true,
                //       scrollDirection: Axis.horizontal,
                //       autoPlay: true,
                //     ),
                //     items: imgList
                //         .map((item) => Container(
                //               decoration: BoxDecoration(
                //                 color: liteGrey,
                //                 image: DecorationImage(
                //                     image: NetworkImage(
                //                       item,
                //                     ),
                //                     fit: BoxFit.cover),
                //               ),
                //             ))
                //         .toList(),
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: imgList.asMap().entries.map((entry) {
                //     return GestureDetector(
                //       onTap: () => _controller.animateToPage(entry.key),
                //       child: Container(
                //         width: 4.0,
                //         height: 4.0,
                //         margin: const EdgeInsets.symmetric(
                //             vertical: 8.0, horizontal: 4.0),
                //         decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color:
                //                 (Theme.of(context).brightness == Brightness.dark
                //                         ? Colors.white
                //                         : Colors.black)
                //                     .withOpacity(
                //                         _current == entry.key ? 0.9 : 0.4)),
                //       ),
                //     );
                //   }).toList(),
                // ),
              ],
            ));
      }
    });
  }
}

class BannerImages {
  static const String banner1 =
      "https://i0.wp.com/www.creativevivid.com/wp-content/uploads/2018/07/Facebook-Food-Banner-Design.jpg?resize=600%2C314&ssl=1";
  static const String banner2 =
      "https://img.lovepik.com/free-template/bg/20200922/bg/c0246804e57f0_415669.png_list.jpg!/fw/431/clip/0x300a0a0";
  static const String banner3 =
      "https://thumbs.dreamstime.com/z/pancake-mix-banner-ads-pancake-mix-banner-ads-honey-dripping-delicious-fluffy-pancakes-fruits-d-illustration-159510804.jpg";
  static const String banner4 =
      "https://img.freepik.com/free-vector/burger-fast-food-advertising-banner-template-hamburger-wooden-board-marketing-poster-cafe_502272-1038.jpg?size=626&ext=jpg";

  static List<BannerModel> listBanners = [
    BannerModel(imagePath: banner1, id: "1"),
    BannerModel(imagePath: banner2, id: "2"),
    BannerModel(imagePath: banner3, id: "3"),
    BannerModel(imagePath: banner4, id: "4"),
  ];
}
