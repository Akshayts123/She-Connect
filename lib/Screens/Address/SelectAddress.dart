import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:she_connect/API/DeleteAddress_api.dart';
import 'package:she_connect/API/listAddress_api.dart';
import 'package:she_connect/API/makeDefaultAddressAPI.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/shimmer.dart';
import 'package:she_connect/Screens/Address/AddNewAddress.dart';
import 'package:she_connect/Screens/Address/EditAddress.dart';

class SelectAddress extends StatefulWidget {
  final name;
  final mob;
  final fromCheck;
  final refresh;
  const SelectAddress(
      {Key? key, this.name, this.mob, this.fromCheck, this.refresh})
      : super(key: key);

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  var arrAddress = [];
  var load = true;
  var updateLoad = false;
  var addressIDD;
  @override
  void initState() {
    super.initState();
    this.getAddress();
    setState(() {});
  }

  Future<String> getAddress() async {
    var rsp = await listAddressAPI();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrAddress = rsp["data"];
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  reee() async {
    var rsp = await listAddressAPI();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrAddress = rsp["data"];
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  int? _groupValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BGgrey,
        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 25)),
            title: const Text("My Address", style: appBarTxtStyl)),
        body: load == true
            ? shimmerAddressList()
            : arrAddress.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/Images/noAddress.png",
                          ),
                          Text(
                            "No Saved Address Found!",
                            style: size14_600,
                          ),
                          h(10),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddNewAddress(
                                            refresh: reee,
                                            name: widget.name.toString(),
                                            mob: widget.mob.toString())));
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: Colors.grey[400]!)),
                                  child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 18),
                                      child: Text("+ Add New Address",
                                          style: size14_600Pink))))
                        ],
                      ),
                    ),
                  )
                : LayoutBuilder(builder: (context, snapshot) {
                    if (snapshot.maxWidth < 600) {
                      return Scrollbar(
                          child: RefreshIndicator(
                        onRefresh: getAddress,
                        child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(children: [
                              ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 5,
                                      ),
                                  shrinkWrap: true,
                                  itemCount: arrAddress != null
                                      ? arrAddress.length
                                      : 0,
                                  itemBuilder: (context, index) {
                                    final item = arrAddress != null
                                        ? arrAddress[index]
                                        : null;
                                    return AddressList(item, index);
                                  }),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddNewAddress(
                                                refresh: reee,
                                                name: widget.name.toString(),
                                                mob: widget.mob.toString())));
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey[400]!)),
                                      child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 18),
                                          child: Text("+ Add New Address",
                                              style: size14_600Pink))))
                            ])),
                      ));
                    } else {
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: arrAddress != null ? arrAddress.length : 0,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 2),
                        itemBuilder: (BuildContext context, int index) {
                          final item = arrAddress != null ? arrAddress : null;
                          return AddressGrid(item, index);
                        },
                      );
                    }
                  }));
  }

  AddressList(var item, int index) {
    print(item);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(item["typeOfAddress"].toString(), style: size16_700),
                const SizedBox(width: 10),
                item["isDefaultAddress"] == true
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: green),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            child: Text("DEFAULT", style: size12_400W)))
                    : Opacity(opacity: 0),
                const Spacer(),
                IconButton(
                    onPressed: () async {
                      deleteAddressAlert(item, index);
                    },
                    icon: Icon(
                      Icons.close_outlined,
                      size: 18,
                    ))
              ]),
              Text(item["name"].toString(), style: size14_600),
              SizedBox(height: 5),
              Text(
                  item["flatNo"].toString() +
                      ", " +
                      item["locality"].toString(),
                  style: size14_400Grey),
              Text(item["city"].toString() + ", " + item["pincode"].toString(),
                  style: size14_400Grey),
              Text(item["state"].toString() + ",", style: size14_400Grey),
              Text("Landmark: " + item["nearestLandmark"].toString(),
                  style: size14_400Grey),
              Text("Phone : " + item["phoneNo"].toString(),
                  style: size14_400Grey),
              Divider(color: darkPink),
              Row(
                children: [
                  GestureDetector(
                    child: Text("Edit", style: size14_600Pink),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditAddress(
                                refresh: reee, data: arrAddress[index])),
                      );
                    },
                  ),
                  w(20),
                  item["isDefaultAddress"] == false
                      ? GestureDetector(
                          child: updateLoad == true
                              ? Center(
                                  child: SpinKitCircle(
                                  color: darkPink,
                                  size: 15,
                                ))
                              : Text("Make default address",
                                  style: size14_600Pink),
                          onTap: () async {
                            setState(() {
                              updateLoad = true;
                            });
                            var rsp = await makeDefaultAddressAPI(
                                item["_id"].toString());
                            if (rsp["status"].toString() == "success") {
                              setState(() {
                                updateLoad = false;
                              });
                              reee();
                              if (widget.fromCheck == true) {
                                Navigator.pop(context);
                                widget.refresh();
                              }
                            }
                          })
                      : Opacity(opacity: 0)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void deleteAddressAlert(var item, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
        elevation: 10,
        title: Text(
          'Confirm delete?',
          style: size14_600,
        ),
        content: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return Text(
                'Are you sure you want to delete this address?',
                style: size12_400Grey,
              );
            }),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              print(item["_id"]);
              var rsp = await deleteAddressAPI(item["_id"]);
              print(rsp);
              if (rsp["status"].toString() == "success") {
                getAddress();
                showToastSuccess("Address Deleted!");
                Navigator.pop(context);
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  AddressGrid(var item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text("Home", style: size16_700),
                const SizedBox(width: 10),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: green),
                    child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: Text("DEFAULT", style: size12_400W))),
                const Spacer(),
                // Radio<int>(
                //     groupValue: _groupValue,
                //     activeColor: darkPink,
                //     toggleable: true,
                //     value: 1,
                //     onChanged: (int? value) {
                //       setState(() {
                //         _groupValue = value;
                //       });
                //     })
              ]),
              const Text("Shankar", style: size14_600),
              const SizedBox(height: 5),
              const Text("Kozhippatta House, Paravur", style: size14_400Grey),
              const Text("Ernakulam", style: size14_400Grey),
              const Text("Kerala, India - 683 562", style: size14_400Grey),
              const Text("Phone : 9893425994", style: size14_400Grey),
              const Divider(color: darkPink),
              const Text("Edit", style: size14_600Pink)
            ],
          ),
        ),
      ),
    );
  }
}
