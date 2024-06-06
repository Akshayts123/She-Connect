import 'package:flutter/material.dart';
import 'package:she_connect/API/relatedVendorsList_API.dart';
import 'package:she_connect/API/viewSingleVendorDetail_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/MainWidgets/shimmer.dart';
import 'package:she_connect/Screens/Vendor/Tabs/VendorDetails.dart';

class vendorsTab extends StatefulWidget {
  final id;
  const vendorsTab({Key? key, this.id}) : super(key: key);

  @override
  _vendorsTabState createState() => _vendorsTabState();
}

class _vendorsTabState extends State<vendorsTab> {
  var arrData;
  var load = true;
  @override
  void initState() {
    super.initState();
    this.getSubCats();
    setState(() {});
  }

  Future<String> getSubCats() async {
    var response = await relatedVendorsAPI(widget.id);
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
      child: load == true
          ? shimmerVendorsGrid()
          : Scrollbar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RefreshIndicator(
                  onRefresh: getSubCats,
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: arrData != null ? arrData.length : 0,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.6),
                      itemBuilder: (BuildContext context, int index) {
                        final item = arrData != null ? arrData[index] : null;

                        return StoresList(item, index);
                      }),
                ),
              ),
            ),
    );
  }

  StoresList(var item, int index) {
    return GestureDetector(
        onTap: () async {
          var vendorID = item["_id"].toString();
          var rsp = await singleVendorDetailAPI(vendorID);
          print("`````````rsp`````````");
          print(rsp);
          print("`````````rsp`````````");

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VendorDetails(data: rsp["data"])));
        },
        child: Column(children: [
          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (Colors.grey[400]!),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  )
                ],
                color: liteGrey,
                border: Border.all(color: Colors.black12),
                image: DecorationImage(
                    image: NetworkImage(
                      vendorBaseUrl + item["image"].toString(),
                    ),
                    fit: BoxFit.cover)),
          ),
          Text(item["name"].toString(),
              style: size16_400, maxLines: 1, overflow: TextOverflow.ellipsis),
          h(5),
          Text(item["city"].toString(), style: size12_400Grey),
          h(5),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.black)),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Text("4.4", style: size12_400),
                    Icon(Icons.star, size: 13)
                  ])))
        ]));
  }
}
