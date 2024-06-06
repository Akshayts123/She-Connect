import 'package:banner_carousel/banner_carousel.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:she_connect/API/homebanner1_API.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/network.dart';

class Homecarousel extends StatefulWidget {
  final data;
  const Homecarousel({Key? key, this.data}) : super(key: key);

  @override
  State<Homecarousel> createState() => _HomecarouselState();
}

class _HomecarouselState extends State<Homecarousel> {
  int _current = 0;
  var arrData;
  var arrImages = [];

  final CarouselController _controller = CarouselController();
  @override
  void initState() {
    super.initState();
    this.getBanners();
    setState(() {});
  }

  Future<String> getBanners() async {
    var rsp = await homeBanners1API();
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AspectRatio(
            aspectRatio: 2.16,
            child: Container(
              color: Colors.white,
              child: Carousel(
                images: arrImages,
                dotSize: 4.0,
                boxFit: BoxFit.cover,
                defaultImage: Image.asset("assets/Images/LogoVector.png"),
                dotSpacing: 10,
                dotColor: liteGrey,
                radius: const Radius.circular(15),
                dotIncreasedColor: Colors.blue[600],
                indicatorBgPadding: 5,
                dotBgColor: Colors.black12.withOpacity(0.1),
                borderRadius: true,
                autoplay: false,
                moveIndicatorFromBottom: 20,
              ),
            ),
          ),
        );
      } else {
        return Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [],
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
