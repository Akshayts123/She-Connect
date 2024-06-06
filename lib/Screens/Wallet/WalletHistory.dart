import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';

class WalletHistory extends StatefulWidget {
  final data;
  const WalletHistory({Key? key, this.data}) : super(key: key);

  @override
  _WalletHistoryState createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  var FinalDateFormat;
  var formatted;
  var arrList;
  var load = true;

  @override
  void initState() {
    super.initState();
    this.getCoupons();
    setState(() {});
  }

  Future<String> getCoupons() async {
    for (var i = 0; i < widget.data.length; i++) {
      // setState(() {
      //   var date = widget.data[i]["createdAt"];
      //   var parsedDate = DateTime.parse(date);
      //   var fr2 = DateFormat.MMMM().format(parsedDate);
      //   FinalDateFormat = "${parsedDate.day}-$fr2-${parsedDate.year}";
      //   formatted = FinalDateFormat;
      // });
    }

    setState(() {
      load = false;
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
          child: ListView.separated(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) => h(10),
              shrinkWrap: true,
              itemCount: widget.data != null ? widget.data.length : 0,
              itemBuilder: (context, index) {
                final item = widget.data != null ? widget.data[index] : null;
                return walletHistoryList(item, index);
              })),
    );
  }

  walletHistoryList(var item, int index) {
    var parsedDate = DateTime.parse(item["createdAt"]);
    var fr2 = DateFormat.MMMM().format(parsedDate);
    FinalDateFormat = "${parsedDate.day} $fr2, ${parsedDate.year}";
    formatted = FinalDateFormat;
    return Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    item["type"].toString() == "CREDIT"
                        ? Text(
                            rs +
                                item["amount"].toString() +
                                " added to rewards.",
                            style: size14_400)
                        : Text(
                            rs +
                                item["amount"].toString() +
                                " deducted from rewards.",
                            style: size14_400),
                    h(5),
                    Text(formatted, style: size12_400Grey)
                  ])),
              w(10),
              item["type"].toString() == "CREDIT"
                  ? Text("+ " + rs + item["amount"].toString(),
                      style: size14_600Green)
                  : Text("- " + rs + item["amount"].toString(),
                      style: size14_600Red)
            ])));
  }
}
