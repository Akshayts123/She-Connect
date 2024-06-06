import 'package:badges/badges.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:she_connect/API/AddToCart_api.dart';
import 'package:she_connect/API/AddToFav_api.dart';
import 'package:she_connect/API/ListCart_api.dart';
import 'package:she_connect/API/RelatedProductsList_API.dart';
import 'package:she_connect/API/getProductReview_API.dart';
import 'package:she_connect/API/productDetialsApi.dart';
import 'package:she_connect/API/removeFromFav.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainScreens/Cart.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Product/carouselFullView.dart';
import 'package:she_connect/Screens/Product/productVarient.dart';
import 'package:she_connect/Screens/ProductReview/addNewReview.dart';
import 'package:she_connect/Screens/ProductReview/allReviews.dart';
import 'package:she_connect/Screens/productPolicyPage.dart';
import 'package:she_connect/testpg.dart';

import '../Vendor/Tabs/VendorDetails.dart';
import '../WishlistScreen.dart';

class ProductDetailsPage extends StatefulWidget {
  final pID;
  const ProductDetailsPage({Key? key, @required this.pID}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  var varientTap;
  var varientID;
  var tapped = false;
  var arrVariantsColor;
  var arrReviews = [];
  var arrVariantsSize;
  var productDetials;
  var arrVendorDetails;
  var varientArray = [];
  var load = true;
  var btTap = false;
  var FinalDateFormat;
  var formatted;
  var finalfav;
  var relatedProductsArr = [];
  var done = false;
  var arrProductImages = [];
  var arrFullCarousel = [];
  var AllImages = [];
  var isFaved;
  var favTap;
  var arrCartLength;
  var varientPrice;
  bool favLoad = false;
  var arrCoverImg = [];

  @override
  void initState() {
    super.initState();
    this.getHome();
    setState(() {});
  }

  Future<String> getCart() async {
    var rsp = await listCartApi();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrCartLength = rsp["data"]["lists"].length;
      });
    }

    setState(() {});
    return "success";
  }

  Future<String> getHome() async {
    var rsp = await productDetailsApi(widget.pID);
    if (rsp["status"].toString() == "success") {
      this.getReviews();
      this.getRealtedProducts();
      productDetials = rsp["data"];
      isFaved = productDetials["isFavorite"];

      List<dynamic> ImageData = productDetials["images"];
      if (ImageData.length != 0) {
        for (var value in ImageData) {
          final image = value["images"];
          arrFullCarousel.add(productImage + image);
          arrProductImages.add(NetworkImage(productImage + image));
        }
      } else {
        print("nulll");
      }
      var mainImg = productDetials["image"];
      arrCoverImg.add(NetworkImage(mainImg));
      AllImages = arrCoverImg + arrProductImages;

      varientArray = productDetials["variants"];
      arrVendorDetails = rsp["data"]["vendor"];
    }

    setState(() {
      load = false;
    });

    return "success";
  }

  Future<String> faveRefresh() async {
    var rsp = await productDetailsApi(widget.pID);
    if (rsp["status"].toString() == "success") {
      productDetials = rsp["data"];
      isFaved = productDetials["isFavorite"];
    }
    setState(() {});
    return "success";
  }

  Future<String> getRealtedProducts() async {
    var rsp = await FavouritesListAPI(widget.pID);
    if (rsp["status"].toString() == "success") {
      relatedProductsArr = rsp["data"]["lists"];
    }

    setState(() {
      load = false;
    });
    return "success";
  }

  Future<String> getReviews() async {
    var rsp = await listAllReviewsAPI(widget.pID);
    if (rsp["status"].toString() == "success") {
      arrReviews = rsp["data"]["lists"];
      for (var i = 0; i < arrReviews.length; i++) {
        var datee = arrReviews;
        setState(() {
          var date = arrReviews[i]["user"]["createdAt"];
          var parsedDate = DateTime.parse(date);
          var fr2 = DateFormat.MMMM().format(parsedDate);
          FinalDateFormat = "${parsedDate.day},$fr2-${parsedDate.year}";
          formatted = FinalDateFormat;
        });
      }
    }
    setState(() {
      load = false;
    });

    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyHomePageModel>(builder: (context, model, child) {
      final model = Provider.of<MyHomePageModel>(context, listen: false);
      int _counter = model.getCounter();
      return Scaffold(
        backgroundColor: liteGrey,
        appBar: AppBar(
          elevation: 1,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Wishlist()),
                  );
                },
                icon: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                    size: 25,
                  ),
                )),
            w(5),
            IconButton(
                onPressed: () {},
                icon: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: const Icon(
                    Icons.share_outlined,
                    color: Colors.black,
                    size: 25,
                  ),
                )),
            w(10),
            GestureDetector(
              child: _counter.toString() != "0"
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Badge(
                        child: Icon(Icons.shopping_cart_outlined, size: 25),
                        badgeContent:
                            Text(_counter.toString(), style: badgeTxt),
                      ),
                    )
                  : Icon(Icons.shopping_cart_outlined, size: 25),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cart()),
                );
              },
            ),
            w(15)
          ],
        ),
        body: load == true
            ? loading()
            : Scrollbar(
                child: RefreshIndicator(
                  onRefresh: getHome,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        TopPreview(),
                        varientArray.length == 0
                            ? Opacity(opacity: 0)
                            : varientArray.length == 1
                                ? Container(
                                    color: Colors.white,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Available Varients",
                                              style: size16_700),
                                          h(10),
                                          Text(varientArray[0]["name"]
                                              .toString()),
                                          h(10),
                                          GridView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: productDetials[
                                                        "productVariants"] !=
                                                    null
                                                ? productDetials[
                                                        "productVariants"]
                                                    .length
                                                : 0,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 10,
                                                    childAspectRatio: 2.5),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final item = productDetials[
                                                          "productVariants"] !=
                                                      null
                                                  ? productDetials[
                                                      "productVariants"][index]
                                                  : null;
                                              return SingleVariant(item, index);
                                            },
                                          )
                                          // SizedBox(
                                          //   height: 45,
                                          //   child: ListView.separated(
                                          //     scrollDirection: Axis.horizontal,
                                          //     physics: BouncingScrollPhysics(),
                                          //     separatorBuilder:
                                          //         (context, index) => SizedBox(
                                          //       width: 5,
                                          //     ),
                                          //     shrinkWrap: true,
                                          //     itemCount: productDetials[
                                          //                 "productVariants"] !=
                                          //             null
                                          //         ? productDetials[
                                          //                 "productVariants"]
                                          //             .length
                                          //         : 0,
                                          //     itemBuilder: (context, index) {
                                          //       final item = productDetials[
                                          //                   "productVariants"] !=
                                          //               null
                                          //           ? productDetials[
                                          //                   "productVariants"]
                                          //               [index]
                                          //           : null;
                                          //
                                          //       return SingleVariant(
                                          //           item, index);
                                          //     },
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: Colors.white,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Available Varients",
                                              style: size16_700),
                                          h(10),
                                          Row(
                                            children: [
                                              Text(varientArray[0]["name"]
                                                  .toString()),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: Container(
                                                    height: 10,
                                                    width: 1,
                                                    color: Colors.black26),
                                              ),
                                              Text(varientArray[1]["name"]
                                                  .toString()),
                                            ],
                                          ),
                                          h(10),
                                          // SizedBox(
                                          //   height: 45,
                                          //   child: ListView.separated(
                                          //     scrollDirection: Axis.horizontal,
                                          //     physics: BouncingScrollPhysics(),
                                          //     separatorBuilder:
                                          //         (context, index) => SizedBox(
                                          //       width: 5,
                                          //     ),
                                          //     shrinkWrap: true,
                                          //     itemCount: productDetials[
                                          //                 "productVariants"] !=
                                          //             null
                                          //         ? productDetials[
                                          //                 "productVariants"]
                                          //             .length
                                          //         : 0,
                                          //     itemBuilder: (context, index) {
                                          //       final item = productDetials[
                                          //                   "productVariants"] !=
                                          //               null
                                          //           ? productDetials[
                                          //                   "productVariants"]
                                          //               [index]
                                          //           : null;
                                          //
                                          //       return MultipleVariants(
                                          //           item, index);
                                          //     },
                                          //   ),
                                          // ),
                                          GridView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: productDetials[
                                                        "productVariants"] !=
                                                    null
                                                ? productDetials[
                                                        "productVariants"]
                                                    .length
                                                : 0,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 5,
                                                    mainAxisSpacing: 5,
                                                    childAspectRatio: 2.5),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final item = productDetials[
                                                          "productVariants"] !=
                                                      null
                                                  ? productDetials[
                                                      "productVariants"][index]
                                                  : null;
                                              return MultipleVariants(
                                                  item, index);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                        //---------------------------------------
                        // productVarient(data: productDetials["productVariants"]),
                        // ListView.separated(
                        //   scrollDirection: Axis.vertical,
                        //   physics: NeverScrollableScrollPhysics(),
                        //   separatorBuilder: (context, index) => SizedBox(
                        //     height: 10,
                        //   ),
                        //   shrinkWrap: true,
                        //   itemCount:
                        //       varientArray != null ? varientArray.length : 0,
                        //   itemBuilder: (context, index) {
                        //     final item = varientArray != null
                        //         ? varientArray[index]
                        //         : null;
                        //
                        //     return VarientTypes(item, index);
                        //   },
                        // ),
                        h(5),
                        prdDetails(),
                        h(5),
                        policy(),
                        h(5),
                        ReviewRating(),
                        h(5),
                        relatedProductsArr.length != 0
                            ? youMayLike()
                            : Opacity(opacity: 0),
                        h(5),
                      ],
                    ),
                  ),
                ),
              ),
        bottomNavigationBar: load == true
            ? loading()
            : LayoutBuilder(builder: (context, snapshot) {
                if (snapshot.maxWidth < 600) {
                  return Container(
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              child: Row(
                                children: [
                                  Text(
                                    "Total Price",
                                    style: size14_600,
                                  ),
                                  tapped == true
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          child: Text(
                                              rs + varientPrice.toString(),
                                              style: size22_600,
                                              textAlign: TextAlign.center),
                                        )
                                      : varientArray.isNotEmpty
                                          ? Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8),
                                                child: Text(
                                                    "Please choose a varient",
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    style: size14_400),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 8),
                                              child: Text(
                                                  rs +
                                                      productDetials[
                                                              "retailPrice"]
                                                          .toString(),
                                                  style: size22_600),
                                            ),
                                ],
                              ),
                            ),
                          ),
                          button(),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rs + productDetials["retailPrice"].toString(),
                                  style: bottomNavPrice,
                                ),
                                Text(
                                  "Total Price",
                                  style: size12_400Grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: button()),
                      ],
                    ),
                  );
                }
              }),
      );
    });
  }

  Widget button() {
    final model = Provider.of<MyHomePageModel>(context, listen: false);

    return done == true
        ? Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cart()),
                );
              },
              child: Container(
                height: 45,
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Text(
                    "GO TO CART",
                    style: size16_600pink,
                    textAlign: TextAlign.center,
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: darkPink),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          )
        : GestureDetector(
            onTap: () async {
              if (varientArray.length != 0) {
                tapped == false
                    ? showToastError("Please select a variant to continue")
                    : btTap = true;
                var rsp = await addToCartApi(
                    productDetials["_id"], 1, varientPrice, varientID);
                print("```````````rsp```````````");
                print(rsp);
                print("````````````rsp````````````");
                if (rsp["status"].toString() == "success") {
                  var rsp = await listCartApi();

                  if (rsp["status"].toString() == "success") {
                    setState(() {
                      arrCartLength = rsp["data"]["lists"].length;
                      model.addCounter(arrCartLength);
                    });
                  }

                  showToastSuccess("Item added to cart");
                  setState(() {
                    btTap = false;
                    done = true;
                  });
                }
              } else {
                // setState(() async {
                btTap = true;
                var rsp = await addToCartApiNovarient(
                    productDetials["_id"], 1, productDetials["retailPrice"]);
                print(rsp);
                if (rsp["status"].toString() == "success") {
                  print("successs");
                  var rsp = await listCartApi();

                  if (rsp["status"].toString() == "success") {
                    setState(() {
                      arrCartLength = rsp["data"]["lists"].length;
                      model.addCounter(arrCartLength);
                    });
                  }
                  showToastSuccess("Item added to cart");
                  setState(() {
                    btTap = false;
                    done = true;
                  });
                }
              }
            },
            child: Container(
              height: 45,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  gradient: buttonGradient,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: btTap == true
                    ? SpinKitThreeBounce(
                        color: Colors.white,
                        size: 18,
                      )
                    : Text(
                        "ADD TO CART",
                        style: size16_600W,
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          );
  }

  Widget TopPreview() {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           carouselFullView(arrImages: arrFullCarousel)),
                        // );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Center(
                          child: Carousel(
                            images: AllImages,
                            onImageTap: (index) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => carouselFullView(
                                        arrImages: arrFullCarousel,
                                        index: index)),
                              );
                              print(index.toString());
                            },
                            dotSize: 4.0,
                            dotSpacing: 15.0,
                            dotColor: liteGrey,
                            radius: const Radius.circular(10),
                            dotIncreasedColor: darkPink,
                            indicatorBgPadding: 5.0,
                            dotBgColor: Colors.black12.withOpacity(0.1),
                            borderRadius: true,
                            autoplay: false,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: () async {
                          if (isFaved == true) {
                            setState(() {
                              favLoad = true;
                            });
                            var rsp =
                                await removeFromFavAPI(productDetials["_id"]);
                            print(rsp);
                            if (rsp["status"].toString() == "succes") {
                              setState(() {
                                favTap = false;
                                favLoad = false;
                              });
                            }
                          } else {
                            setState(() {
                              favLoad = true;
                            });
                            var rsp = await AddToFavAPI(productDetials["_id"]);
                            print(rsp);
                            if (rsp["status"].toString() == "success") {
                              setState(() {
                                favTap = true;
                                favLoad = false;
                              });
                            }
                          }
                          faveRefresh();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.black12,
                          maxRadius: 18,
                          child: favLoad == true
                              ? SpinKitPumpingHeart(
                                  color: Colors.red,
                                  size: 25,
                                )
                              : isFaved == true
                                  ? Icon(Icons.favorite,
                                      color: Colors.red, size: 24)
                                  : Icon(Icons.favorite,
                                      color: Colors.white, size: 24),
                        ),
                      ),
                      bottom: 35,
                      right: 30,
                    ),
                  ],
                ),
                h(10),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 20, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productDetials["name"].toString(),
                        style: size20_400,
                      ),
                      h(5),
                      Text(
                        productDetials["caption"].toString(),
                        style: size16_400,
                      ),
                      h(15),
                      Row(
                        children: [
                          arrReviews.length == 0
                              ? Opacity(opacity: 0)
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: liteGrey),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: Row(
                                      children: [
                                        Text(
                                          productDetials["averageRating"]
                                              .toString(),
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
                          arrReviews.length == 0
                              ? Opacity(opacity: 0)
                              : Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  height: 18,
                                  width: 1,
                                  color: Colors.grey[400],
                                ),
                          Text(
                            productDetials["totalReviewCount"].toString() +
                                " Reviews",
                            style: size12_400Grey,
                          )
                        ],
                      ),
                      h(5),
                      tapped == true
                          ? Wrap(
                              spacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(rs + varientPrice.toString(),
                                    style: size20_400,
                                    textAlign: TextAlign.center),
                                Text(
                                  rs + productDetials["listPrice"].toString(),
                                  style: size16_400PinkCut,
                                ),
                              ],
                            )
                          : varientArray.isEmpty
                              ? Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  children: [
                                    // Text(rs + productDetials["retailPrice"].toString(),
                                    //     style: size20_400),
                                    Text(
                                      rs +
                                          productDetials["retailPrice"]
                                              .toString(),
                                      style: size20_400,
                                    ),

                                    Text(
                                      rs +
                                          productDetials["listPrice"]
                                              .toString(),
                                      style: size16_400PinkCut,
                                    ),
                                  ],
                                )
                              : Text("Select Variant for price"),
                      h(5),
                      const Text(
                        "Price inclusive of all taxes",
                        style: size12_400Grey,
                      ),
                      h(15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VendorDetails(data: arrVendorDetails)),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Vendor: ",
                              style: size14_600Grey,
                            ),
                            w(10),
                            arrVendorDetails != null
                                ? Text(
                                    arrVendorDetails["name"].toString(),
                                    style: size14_600Pink,
                                  )
                                : Opacity(opacity: 0),
                            const Icon(
                              Icons.arrow_right,
                              color: darkPink,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                      // Offer(),
                      // h(10),
                      // Row(
                      //   children: const [
                      //     Spacer(),
                      //     Padding(
                      //       padding: EdgeInsets.only(right: 15),
                      //       child: Text(
                      //         "+2 More Offers",
                      //         style: size14_600Pink,
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
              ],
            ));
      } else {
        return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Center(
                        child: Carousel(
                          images: const [
                            NetworkImage(
                                'https://fifthavenuegirl.com/wp-content/uploads/2020/06/Top-10-Classic-Louis-Vuitton-Handbags.jpg'),
                            NetworkImage(
                                'https://us.louisvuitton.com/images/is/image/M45320_PM2_Front%20view'),
                          ],
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          dotColor: liteGrey,
                          radius: const Radius.circular(20),
                          dotIncreasedColor: darkPink,
                          indicatorBgPadding: 5.0,
                          dotBgColor: Colors.black12.withOpacity(0.1),
                          borderRadius: true,
                        ),
                      ),
                    ),
                    const Positioned(
                      child: CircleAvatar(
                        backgroundColor: Colors.black12,
                        maxRadius: 18,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      bottom: 35,
                      right: 30,
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 18, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Surene tote Bag",
                        style: size22_600,
                      ),
                      h(5),
                      const Text(
                        "Louis Vuitton Grey and Red Lady Bag",
                        style: size16_400,
                      ),
                      h(5),
                      Row(
                        children: [
                          Container(
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
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            height: 18,
                            width: 1,
                            color: Colors.grey[400],
                          ),
                          const Text(
                            "146 reviews",
                            style: size12_400Grey,
                          )
                        ],
                      ),
                      h(5),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: const [
                          Text(
                            rs + "45,999",
                            style: size16_700,
                          ),
                          Text(
                            rs + "55,999",
                            style: size16_400Grey,
                          ),
                          Text(
                            "25% Discount",
                            style: size14_600Grey,
                          )
                        ],
                      ),
                      h(5),
                      const Text(
                        "Price inclusive of all taxes",
                        style: size12_400Grey,
                      ),
                      h(5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VendorDetails()),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Vendor: ",
                              style: size14_600Grey,
                            ),
                            w(10),
                            const Text(
                              "Louis Vuitton",
                              style: size14_600Pink,
                            ),
                            const Icon(
                              Icons.arrow_right,
                              color: darkPink,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                      h(10),
                      Offer(),
                      h(10),
                      Row(
                        children: const [
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Text(
                              "+2 More Offers",
                              style: size14_600Pink,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ));
      }
    });
  }

  Widget Offer() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
          color: liteGrey),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Free Delivery on First Order.",
                    style: size14_600,
                  ),
                  Text(
                    "On order over 500/-",
                    style: size12_400Grey,
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Use Code",
                    style: size13_400,
                  ),
                  Text(
                    "FIRSTBUY".toUpperCase(),
                    style: size14_600,
                  ),
                  const Text(
                    "T&C",
                    style: size12_400Grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorSlct() {
    return varientArray.isNotEmpty
        ? Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Colour ",
                    style: size16_700,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 55,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => w(15),
                      shrinkWrap: true,
                      itemCount: arrVariantsColor != null
                          ? arrVariantsColor.length
                          : 0,
                      itemBuilder: (context, index) {
                        final item = arrVariantsColor != null
                            ? arrVariantsColor[index]
                            : null;

                        return colorList(item, index);
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        : Opacity(opacity: 0);
  }

  // Widget sizeSlct() {
  //   return varientArray.isNotEmpty
  //       ? Container(
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10), color: Colors.white),
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "Select Size",
  //                   style: size16_700,
  //                 ),
  //                 h(10),
  //                 SizedBox(
  //                   height: 35,
  //                   child: ListView.separated(
  //                     scrollDirection: Axis.horizontal,
  //                     separatorBuilder: (context, index) => w(10),
  //                     shrinkWrap: true,
  //                     itemCount:
  //                         arrVariantsSize != null ? arrVariantsSize.length : 0,
  //                     itemBuilder: (context, index) {
  //                       final item = arrVariantsSize != null
  //                           ? arrVariantsSize[index]
  //                           : null;
  //
  //                       return SizeList(item, index);
  //                     },
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         )
  //       : Opacity(opacity: 0);
  // }

  colorList(var item, int index) {
    return Column(
      children: [
        Text(
          item["name"].toString(),
          style: size14_400Grey,
        ),
        h(8),
        CircleAvatar(radius: 12, backgroundColor: Colors.green)
      ],
    );
  }

  SizeList(var item, int index) {
    return Container(
      height: 37,
      width: 37,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: liteGrey,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        item["values"][index]["name"].toString(),
        style: size14_600,
      ),
    );
  }

  Widget prdDetails() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Product Details",
              style: size16_700,
            ),
            const SizedBox(
              height: 15,
            ),
            Html(data: productDetials["description"].toString()),
            // Text(productDetials["description"].toString()),
            // ListView.separated(
            //   scrollDirection: Axis.vertical,
            //   physics: const NeverScrollableScrollPhysics(),
            //   separatorBuilder: (context, index) => h(10),
            //   shrinkWrap: true,
            //   itemCount: 3,
            //   itemBuilder: (context, index) {
            //     return prdDetailsList(index);
            //   },
            // )
          ],
        ),
      ),
    );
  }

  Widget policy() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Policy",
              style: size16_700,
            ),
            h(15),
            RichText(
              text: TextSpan(
                  text:
                      'Easy 7 days Return and Exchange. Return Policies may vary based on products and promotions. For more details',
                  style: size12_400Grey,
                  children: [
                    TextSpan(
                      text: ' Click here',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductPolicyPage(
                                      data: productDetials["productPolicy"])),
                            ),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          fontSize: 12),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  prdDetailsList(int index) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: Colors.grey[400],
          size: 5,
        ),
        w(5),
        const Text(
          "Material - Calf Leather",
          style: size14_600Grey,
        )
      ],
    );
  }

  Widget ReviewRating() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Rating & Review", style: size20_400),
            h(30),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            productDetials["averageRating"].toString(),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          w(5),
                          const Icon(
                            Icons.star,
                            color: Colors.black,
                            size: 25,
                          ),
                        ],
                      ),
                      Text(
                        productDetials["totalReviewCount"].toString() +
                            " Reviews",
                        style: size14_400Grey,
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: 1,
                  color: Colors.grey[400],
                )
              ],
            ),
            h(30),
            Text(
              "Customer Review (" + arrReviews.length.toString() + ")",
              style: size16_700,
            ),
            h(15),
            ListView.separated(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => h(20),
              shrinkWrap: true,
              itemCount: arrReviews != null && arrReviews.length <= 3
                  ? arrReviews.length
                  : 3,
              itemBuilder: (context, index) {
                final item = arrReviews != null ? arrReviews[index] : null;
                return reviewList(item, index);
              },
            ),
            h(30),
            arrReviews.length >= 3
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllReview(
                                id: widget.pID,
                                data: productDetials,
                                refresh: getHome)),
                      );
                    },
                    child: Text(
                      " View All Reviews",
                      style: size16_400Pink,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNewReview(
                                id: widget.pID,
                                data: productDetials,
                                refresh: getHome)),
                      );
                    },
                    child: Text("+ Add Review", style: size16_400Pink)),
            h(30),
          ],
        ),
      ),
    );
  }

  reviewList(var item, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: liteGrey),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Row(
              children: [
                Text(
                  item["rating"].toString(),
                  style: size12_400,
                ),
                Icon(
                  Icons.star,
                  color: Colors.blueGrey,
                  size: 12,
                )
              ],
            ),
          ),
        ),
        w(20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["review"].toString(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: size16_400,
              ),
              h(5),
              Row(children: [
                Text(
                  item["user"]["name"].toString(),
                  style: size13_400,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: 1,
                    height: 15,
                    color: Colors.grey[400],
                  ),
                ),
                Text(
                  formatted,
                  style: size13_400,
                ),
              ])
            ],
          ),
        )
      ],
    );
  }

  Widget youMayLike() {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "You may also like",
                  style: size16_700,
                ),
                h(15),
                SizedBox(
                  height: 280,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => w(10),
                    shrinkWrap: true,
                    itemCount: relatedProductsArr != null
                        ? relatedProductsArr.length
                        : 0,
                    itemBuilder: (context, index) {
                      final item = relatedProductsArr != null
                          ? relatedProductsArr
                          : null;
                      return recomendedList(item, index);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      } else {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "You may also like",
                  style: size16_700,
                ),
                h(15),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => w(10),
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return recomendedListTablet(index);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }
    });
  }

  recomendedList(var item, int index) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailsPage(pID: item[index]["_id"])),
              );
            },
            child: Container(
              width: 178,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 213,
                    width: 178,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                productImage + item[index]["image"].toString()),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10),
                        color: liteGrey,
                        border: Border.all(color: Colors.black12)),
                  ),
                  h(8),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      item[index]["name"].toString(),
                      style: size14_400,
                    ),
                  ),
                  h(5),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 5),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          rs + item[index]["retailPrice"].toString(),
                          style: size16_400,
                        ),
                        w(10),
                        item[index]["listPrice"].toString() == "0"
                            ? Opacity(opacity: 0)
                            : Text(
                                rs + item[index]["listPrice"].toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.lineThrough),
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  VarientTypes(var item, int index) {
    return productVarient(data: productDetials["productVariants"]);
  }

  recomendedListTablet(int index) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: NetworkImage(bag), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10),
                      color: liteGrey,
                      border: Border.all(color: Colors.black12)),
                ),
                h(5),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "Silverline Hand Bag",
                    style: size12_400,
                  ),
                ),
                h(5),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        rs + "45,000",
                        style: size12_400,
                      ),
                      Text(
                        rs + "55,000",
                        style: size12_400Cross,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  MultipleVariants(var item, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          varientTap = index;
          tapped = true;
          varientID = item["_id"];
          print(varientID);
          varientPrice = item["totalPrice"];
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(
                color: varientTap == index ? darkPink : Colors.white, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: item["variantCombinations"].length == 1
              ? Text(
                  item["variantCombinations"][0]["value"]["name"]
                      .toString()
                      .toUpperCase(),
                  style: varientTap == index ? size14_600 : size14_400Grey)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        item["variantCombinations"][0]["value"]["name"]
                            .toString()
                            .toUpperCase(),
                        style:
                            varientTap == index ? size14_600 : size14_400Grey),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                          height: 15,
                          width: 1,
                          color: varientTap == index
                              ? Colors.black
                              : Colors.black26),
                    ),
                    Text(
                        item["variantCombinations"][1]["value"]["name"]
                            .toString()
                            .toUpperCase(),
                        style:
                            varientTap == index ? size14_600 : size14_400Grey),
                  ],
                ),
        ),
      ),
    );
  }

  SingleVariant(var item, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          varientTap = index;
          tapped = true;
          varientID = item["_id"];
          varientPrice = item["totalPrice"];
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(
                color: varientTap == index ? darkPink : Colors.white, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
              item["variantCombinations"][0]["value"]["name"]
                  .toString()
                  .toUpperCase(),
              style: varientTap == index ? size14_600 : size14_400Grey),
        ),
      ),
    );
  }
}
