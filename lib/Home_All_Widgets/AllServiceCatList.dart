import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';

class AllServiceCatList extends StatefulWidget {
  final arrData;
  const AllServiceCatList({Key? key, this.arrData}) : super(key: key);

  @override
  _AllServiceCatListState createState() => _AllServiceCatListState();
}

class _AllServiceCatListState extends State<AllServiceCatList> {
  var arrServiceCat;
  @override
  void initState() {
    super.initState();
    this.getHome();
    setState(() {});
  }

  Future<String> getHome() async {
    var rsp = widget.arrData;
    arrServiceCat = rsp["serviceCategory"]["lists"];
    print("arrServiceCat");
    print(arrServiceCat);
    setState(() {});
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    shrinkWrap: true,
                    itemCount:
                        arrServiceCat != null && arrServiceCat.length <= 4
                            ? arrServiceCat.length
                            : 4,
                    itemBuilder: (context, index) {
                      final item =
                          arrServiceCat != null ? arrServiceCat[index] : null;

                      return AllServicList(item, index);
                    })));
      } else {
        return Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    shrinkWrap: true,
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return AllServicListTablet(index);
                    })));
      }
    });
  }

  AllServicList(var item, int index) {
    return GestureDetector(
      onTap: () {},
      child: Column(children: [
        Stack(
          children: [
            Positioned(
              bottom: 3,
              left: 5,
              child: CircleAvatar(
                radius: 17,
                backgroundColor: prdCategoryCircleClr,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.2,
              child: Center(
                  child: Image.network(
                      "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.shareicon.net%2Fdata%2F2015%2F10%2F17%2F657543_delivery_512x512.png&f=1&nofb=1",
                      height: 47,
                      width: 47,
                      fit: BoxFit.contain)),
            )
          ],
        ),
        Expanded(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.18,
          child: Text(item["name"].toString(),
              style: size12_400, maxLines: 2, textAlign: TextAlign.center),
        ))
      ]),
    );
  }

  AllServicListTablet(int index) {
    return Column(children: [
      Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.1,
          child: Center(
              child: Image.network(
                  "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.shareicon.net%2Fdata%2F2015%2F10%2F17%2F657543_delivery_512x512.png&f=1&nofb=1",
                  height: 35,
                  fit: BoxFit.contain)),
          decoration:
              const BoxDecoration(color: liteGrey, shape: BoxShape.circle)),
      Expanded(
          child: Text(
        "Courier",
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02),
      ))
    ]);
  }
}
