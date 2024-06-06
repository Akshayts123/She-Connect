import 'package:flutter/material.dart';
import 'package:she_connect/API/viewSingleVendorDetail_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Screens/Vendor/Tabs/VendorDetails.dart';

class FeaturedStores extends StatefulWidget {
  final vendors;
  const FeaturedStores({Key? key, this.vendors}) : super(key: key);

  @override
  _FeaturedStoresState createState() => _FeaturedStoresState();
}

class _FeaturedStoresState extends State<FeaturedStores> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => w(20),
              shrinkWrap: true,
              itemCount: widget.vendors != null ? widget.vendors.length : 0,
              itemBuilder: (context, index) {
                final item =
                    widget.vendors != null ? widget.vendors[index] : null;

                return FeaturedList(item, index);
              },
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => w(20),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return FeaturedListTablet(index);
              },
            ),
          ),
        );
      }
    });
  }

  FeaturedList(var item, int index) {
    return GestureDetector(
      onTap: () async {
        var vendorID = item["_id"].toString();
        var rsp = await singleVendorDetailAPI(vendorID);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VendorDetails(data: rsp["data"])));
      },
      child: Column(
        children: [
          Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (Colors.grey[300]!),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
                color: liteGrey,
                border: Border.all(color: Colors.black12),
                image: DecorationImage(
                    image: NetworkImage(
                      vendorBaseUrl + item["image"].toString(),
                    ),
                    fit: BoxFit.cover)),
          ),
          h(8),
          Text(
            item["name"].toString(),
            style: size16_400,
          ),
          h(5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.black),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  Text(
                    item["averageRating"] != null
                        ? item["averageRating"].toString()
                        : "0",
                    style: size12_400,
                  ),
                  Icon(
                    Icons.star,
                    size: 13,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  FeaturedListTablet(int index) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.15,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (Colors.grey[400]!),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 3),
                ),
              ],
              color: liteGrey,
              border: Border.all(color: Colors.black12),
              image: const DecorationImage(
                  image: NetworkImage(
                    tstImg3,
                  ),
                  fit: BoxFit.cover)),
        ),
        const Text(
          "Stop & Shop",
          style: size16_400,
        ),
        h(5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Row(
              children: const [
                Text(
                  "4.4",
                  style: size12_400,
                ),
                Icon(
                  Icons.star,
                  size: 13,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
