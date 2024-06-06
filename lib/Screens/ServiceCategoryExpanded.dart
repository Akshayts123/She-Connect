import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/MainWidgets/loading.dart';

class ServiceCategoryExpanded extends StatefulWidget {
  final arrData;
  ServiceCategoryExpanded({Key? key, this.arrData}) : super(key: key);

  @override
  _ServiceCategoryExpandedState createState() =>
      _ServiceCategoryExpandedState();
}

class _ServiceCategoryExpandedState extends State<ServiceCategoryExpanded> {
  var arrPrdCat;
  var arrServiceCat;
  var isLoad = true;

  @override
  void initState() {
    super.initState();
    this.getHome();
    setState(() {});
  }

  Future<String> getHome() async {
    var rsp = widget.arrData;
    arrPrdCat = rsp["productCategory"];
    arrServiceCat = rsp["serviceCategory"]["lists"];
    setState(() {
      isLoad = false;
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            )),
        title: const Text(
          "All in Service Categories",
          style: appBarTxtStyl,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border,
                size: 25,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 25,
              )),
        ],
      ),
      body: LayoutBuilder(builder: (context, snapshot) {
        if (snapshot.maxWidth < 600) {
          return isLoad == true
              ? loading()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: arrServiceCat != null ? arrServiceCat.length : 0,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 5,
                            childAspectRatio: 0.52),
                    itemBuilder: (BuildContext context, int index) {
                      final item = arrServiceCat != null ? arrServiceCat : null;

                      return GridItem(item, index);
                    },
                  ),
                );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 11,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.9),
              itemBuilder: (BuildContext context, int index) {
                return GridItemTablet(index);
              },
            ),
          );
        }
      }),
    );
  }

  GridItem(var item, int index) {
    return Column(
      children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.15,
          backgroundColor: liteGrey,
          child: Image.network(
            "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.shareicon.net%2Fdata%2F2015%2F10%2F17%2F657543_delivery_512x512.png&f=1&nofb=1",
            width: MediaQuery.of(context).size.width * 0.1,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
          child: Text(
            item[index]["name"].toString(),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: size12_400,
          ),
        )
      ],
    );
  }

  GridItemTablet(int index) {
    return Column(
      children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.05,
          backgroundColor: liteGrey,
          child: Image.network(
            "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.shareicon.net%2Fdata%2F2015%2F10%2F17%2F657543_delivery_512x512.png&f=1&nofb=1",
            width: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
          child: const Text(
            "Courier Service",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: size12_400,
          ),
        )
      ],
    );
  }
}
