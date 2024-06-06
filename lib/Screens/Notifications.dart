import 'package:flutter/material.dart';
import 'package:she_connect/API/notofication_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/MainWidgets/loading.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var arrNoti = [];
  @override
  void initState() {
    super.initState();
    this.getNoti();
    setState(() {});
  }

  var load = true;
  Future<String> getNoti() async {
    var rsp = await notificationListAPI();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrNoti = rsp["data"];
        print(arrNoti);
      });
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: liteGrey,
        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 25)),
            title: const Text("Notifications", style: appBarTxtStyl)),
        body: load == true
            ? Center(child: loading())
            : arrNoti.isEmpty
                ? noNoti()
                : LayoutBuilder(builder: (context, snapshot) {
                    if (snapshot.maxWidth < 600) {
                      return Scrollbar(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: RefreshIndicator(
                            onRefresh: getNoti,
                            child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                separatorBuilder: (context, index) => h(10),
                                shrinkWrap: true,
                                itemCount: arrNoti != null ? arrNoti.length : 0,
                                itemBuilder: (context, index) {
                                  final item = arrNoti != null ? arrNoti : null;
                                  return NotiList(item, index);
                                }),
                          ),
                        ),
                      );
                    } else {
                      return Scrollbar(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              separatorBuilder: (context, index) => h(20),
                              shrinkWrap: true,
                              itemCount: arrNoti != null ? arrNoti.length : 0,
                              itemBuilder: (context, index) {
                                final item = arrNoti != null ? arrNoti : null;
                                return NotiListTablet(item, index);
                              }),
                        ),
                      );
                    }
                  }));
  }

  NotiList(var item, int index) {
    return Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: (Colors.grey[300]!),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 3),
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item[index]["notificationData"]["title"].toString(),
                  style: size14_700),
              _gap(5),
              Text(item[index]["notificationData"]["body"].toString(),
                  style: size14_400Grey),
              // _gap(15),
              // Container(
              //     width: double.infinity,
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       border: Border.all(color: darkPink),
              //     ),
              //     child: const Padding(
              //         padding: EdgeInsets.symmetric(vertical: 5),
              //         child: Text("SHOP NOW", style: size18_400Pink)))
            ])));
  }

  NotiListTablet(var item, int index) {
    return Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: (Colors.grey[300]!),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 3),
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item[index]["notificationData"].toString(),
                      style: size14_700),
                  _gap(5),
                  const Text("A DEAL TOO GOOD TO BE TRUE!",
                      style: size14_400Grey),
                  _gap(15),
                  Center(
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: darkPink, width: 1),
                        ),
                        child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Text(
                              "SHOP NOW",
                              style: size18_400Pink,
                            ))),
                  )
                ])));
  }

  _gap(double h) {
    return SizedBox(height: h);
  }

  noNoti() {
    return Container(
        child: Center(
            child: Opacity(
                opacity: 0.5,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/Images/noNoti.png",
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.5,
                        fit: BoxFit.contain,
                      ),
                      const Text("No Notifications", style: size20_400)
                    ]))));
  }
}
