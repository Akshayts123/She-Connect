import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';

class SplOccDeals extends StatefulWidget {
  final data;
  const SplOccDeals({Key? key, this.data}) : super(key: key);

  @override
  _SplOccDealsState createState() => _SplOccDealsState();
}

class _SplOccDealsState extends State<SplOccDeals> {
  var arrOffers;
  @override
  void initState() {
    super.initState();
    this.getHome();
    setState(() {});
  }

  Future<String> getHome() async {
    var rsp = widget.data;
    arrOffers = rsp["offer"]["lists"];
    setState(() {});
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Container(
          color: bgLiteHilightColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: arrOffers != null && arrOffers.length <= 4
                  ? arrOffers.length
                  : 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9),
              itemBuilder: (BuildContext context, int index) {
                final item = arrOffers != null ? arrOffers[index] : null;

                return Grid(item, index);
              },
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 8,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              return TabGrid(index);
            },
          ),
        );
      }
    });
  }

  Grid(var item, int index) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
              image: NetworkImage(specialOccDealImage), fit: BoxFit.cover)),
    );
  }

  TabGrid(int index) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
              image: NetworkImage(specialOccDealImage), fit: BoxFit.cover)),
    );
  }
}
