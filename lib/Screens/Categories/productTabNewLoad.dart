import 'package:flutter/material.dart';
import 'package:she_connect/API/productDetialsApi.dart';
import 'package:she_connect/API/viewFullCatProducts_API.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/MainWidgets/shimmer.dart';
import 'package:she_connect/Screens/Product/ProductDetailsPage.dart';

class productsTabNewLoad extends StatefulWidget {
  final id;
  const productsTabNewLoad({Key? key, this.id}) : super(key: key);

  @override
  _productsTabNewLoadState createState() => _productsTabNewLoadState();
}

class _productsTabNewLoadState extends State<productsTabNewLoad> {
  var arrData;
  var load = true;
  @override
  void initState() {
    super.initState();
    this.getSubCats();
    setState(() {});
  }

  Future<String> getSubCats() async {
    var response = await viewFullProductsAPI(widget.id);
    if (response["status"].toString() == "success") {
      setState(() {
        arrData = response["data"]["lists"];
      });
      setState(() {
        load = false;
      });
    }
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: load == true
            ? shimmerProductsGrid()
            : Scrollbar(
                child: RefreshIndicator(
                  onRefresh: getSubCats,
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    // itemCount: 5,
                    itemCount: arrData != null ? arrData.length : 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 0,
                      childAspectRatio: 0.59,
                      mainAxisExtent: 270,
                      // childAspectRatio: MediaQuery.of(context).size.width /
                      //     (MediaQuery.of(context).size.height / 1.2)
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final item = arrData != null ? arrData : null;
                      return TdyDealGrid(item, index);
                    },
                  ),
                ),
              ),
      ),
    );
  }

  TdyDealGrid(var item, int index) {
    return GestureDetector(
      onTap: () async {
        var prdID = item[index]["_id"];

        var rsp = await productDetailsApi(prdID);
        print(rsp);
        arrData = rsp["data"];
        if (rsp["status"].toString() == "success") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsPage(pID: prdID)),
          );
        }
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
              item[index]["avgRating"].toString() == "0"
                  ? Opacity(opacity: 0)
                  : Positioned(
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
                            children: [
                              Text(
                                item[index]["avgRating"].toString(),
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
              item[index]["listPrice"].toString() != "0"
                  ? Text(
                      rs + item[index]["listPrice"].toString(),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.lineThrough),
                    )
                  : Opacity(opacity: 0),
            ],
          ),
        ],
      ),
    );
  }
}
