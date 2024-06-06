import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:she_connect/API/nearestVendorAPI.dart';
import 'package:she_connect/API/topRatedVendorsAPI.dart';
import 'package:she_connect/API/viewSingleVendorDetail_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/MainWidgets/shimmer.dart';
import 'package:she_connect/Screens/Vendor/Tabs/VendorDetails.dart';

import '../../../API/listAllVendors_API.dart';
import '../../SelectLocation.dart';

class FeaturedStoresScreen extends StatefulWidget {
  const FeaturedStoresScreen({Key? key}) : super(key: key);

  @override
  _FeaturedStoresScreenState createState() => _FeaturedStoresScreenState();
}

class _FeaturedStoresScreenState extends State<FeaturedStoresScreen> {
  bool _value = false;
  int val = 1;
  var load = true;
  var head = "VIEW BY";
  var arrVendors = [];
  var arrVendorData = [];

  var lat;
  var long;
  @override
  void initState() {
    super.initState();
    this.getVendors();
    setState(() {});
  }

  Future<String> getVendors() async {
    var rsp = await listVendorsAPI();
    await getLocation();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrVendors = rsp["data"]["lists"];
      });
      setState(() {
        load = false;
      });
    }
    return "success";
  }

  Future<String> sortingCall() async {
    var rsp = await topRatedVendorsAPI();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrVendors = rsp["data"]["lists"];
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  Future<String> nearest() async {
    var rsp = await nearestVendorsAPI(lat.toString(), long.toString());
    print(rsp);
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrVendors = rsp["data"]["lists"];
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      printLocation();
    } else {
      requestPermission();
    }
  }

  requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      printLocation();
    } else {
      requestPermission();
    }
  }

  printLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10));
    lat = position.latitude;
    long = position.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 25)),
            title: const Text("Featured Stores", style: appBarTxtStyl)),
        body: load == true
            ? shimmerVendorsGrid()
            : LayoutBuilder(builder: (context, snapshot) {
                if (snapshot.maxWidth < 600) {
                  return Scrollbar(
                    child: SingleChildScrollView(
                        child: Column(children: [
                      h(10),
                      GestureDetector(
                          onTap: () {
                            _sortBottom();
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(head.toString(), style: size14_700),
                                Icon(Icons.arrow_drop_down, color: Colors.black)
                              ])),
                      arrVendors.length == 0
                          ? Container(
                              child: Center(
                                  child: Text("No nearby vendors to show!",
                                      style: size14_700)),
                              height: MediaQuery.of(context).size.height * 0.6,
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  arrVendors != null ? arrVendors.length : 0,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.75),
                              itemBuilder: (BuildContext context, int index) {
                                final item = arrVendors != null
                                    ? arrVendors[index]
                                    : null;

                                return StoresList(item, index);
                              })
                    ])),
                  );
                } else {
                  return Scrollbar(
                    child: SingleChildScrollView(
                        child: Column(children: [
                      h(10),
                      GestureDetector(
                          onTap: () {
                            _sortBottom();
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Recommended", style: size14_700),
                                Icon(Icons.arrow_drop_down, color: Colors.black)
                              ])),
                      GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 20,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.65),
                          itemBuilder: (BuildContext context, int index) {
                            return StoresListTablet(index);
                          })
                    ])),
                  );
                }
              }));
  }

  StoresList(var item, int index) {
    return GestureDetector(
        onTap: () async {
          var vendorID = item["_id"].toString();
          var rsp = await singleVendorDetailAPI(vendorID);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VendorDetails(data: rsp["data"])));
        },
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.4,
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
          Text(
            item["name"].toString(),
            style: size16_400,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          h(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item["city"].toString(),
                style: size12_400Grey,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              item["distance"] != null
                  ? Text(
                      " (" + item["distance"].toStringAsFixed(2) + " KM" + ")",
                      style: size12_700Grey)
                  : Opacity(opacity: 0)
            ],
          ),
          h(5),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.black)),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                        item["averageRating"] != null
                            ? item["averageRating"].toString()
                            : "0",
                        style: size12_400),
                    Icon(Icons.star, size: 13)
                  ])))
        ]));
  }

  StoresListTablet(int index) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SelectLocation()));
        },
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.2,
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
                image: const DecorationImage(
                    image: NetworkImage(tstImg3), fit: BoxFit.cover)),
          ),
          const Text("Stop & Shop", style: size16_400),
          h(5),
          const Text("Bakery", style: size14_400Grey),
          h(8),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.black)),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Text("4.4", style: size14_600),
                    Icon(Icons.star, size: 18)
                  ])))
        ]));
  }

  _sortBottom() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Stack(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Container(
                        height: 60,
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(children: [
                              const Expanded(
                                  child: Text("VIEW BY",
                                      textAlign: TextAlign.center,
                                      style: size16_700)),
                              IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ]))),
                    // Row(children: [
                    //   Radio(
                    //       value: 1,
                    //       groupValue: val,
                    //       onChanged: (value) {},
                    //       activeColor: Colors.green),
                    //   const Text("Reccomended", style: size16_400)
                    // ]),
                    Row(children: [
                      Radio(
                        value: 2,
                        groupValue: val,
                        onChanged: (value) {
                          setState(() {
                            head = "Top Rated";
                            buttonValue(value!);
                            load = true;
                          });
                          sortingCall();
                          Navigator.pop(context);
                        },
                        activeColor: Colors.green,
                      ),
                      const Text("Top Rated", style: size16_400)
                    ]),
                    Row(children: [
                      Radio(
                          value: 3,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              head = "Nearest";
                              load = true;

                              buttonValue(value!);
                            });
                            nearest();
                            Navigator.pop(context);
                          },
                          activeColor: Colors.green),
                      const Text("Nearest", style: size16_400)
                    ]),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            top: 10))
                  ]))
            ]));
  }

  void buttonValue(v) {
    setState(() {
      val = v;
    });
  }
}
