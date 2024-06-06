import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';

class productVarient extends StatefulWidget {
  // final item;
  // final index;
  final data;
  const productVarient({Key? key, this.data}) : super(key: key);

  @override
  _productVarientState createState() => _productVarientState();
}

class _productVarientState extends State<productVarient> {
  var varientTap;
  var varientID;
  var tapped = false;
  var isAvailable = false;
  var choosenFinal = null;
  var arrData;
  @override
  void initState() {
    super.initState();
    setState(() {
      arrData = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Available Varients", style: size16_700),
            // Text(widget.item["name"].toString(), style: size16_700),
            h(15),
            // SizedBox(
            //   height: 45,
            //   child: ListView.separated(
            //     scrollDirection: Axis.horizontal,
            //     physics: NeverScrollableScrollPhysics(),
            //     separatorBuilder: (context, index) => SizedBox(width: 10),
            //     shrinkWrap: true,
            //     itemCount: widget.item["values"] != null
            //         ? widget.item["values"].length
            //         : 0,
            //     itemBuilder: (context, index) {
            //       final v = widget.item != null ? widget.item : null;
            //       return AvailableVarients(v, index);
            //     },
            //   ),
            // )
            //----------------------------------------------------
            SizedBox(
              height: 45,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(
                  width: 10,
                ),
                shrinkWrap: true,
                itemCount: arrData != null ? arrData.length : 0,
                itemBuilder: (context, index) {
                  final item = arrData != null ? arrData[index] : null;

                  return list(item, index);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  list(var item, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          varientTap = index;
          tapped = true;
        });
        print(item["_id"]);
        print(item["totalPrice"]);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(
                color: varientTap == index ? darkPink : Colors.white, width: 2),
            borderRadius: BorderRadius.circular(3),
            color: Colors.grey[300]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
              item["variantCombinations"][0]["value"]["name"].toString() +
                  " " +
                  item["variantCombinations"][1]["value"]["name"].toString()),
        ),
      ),
    );
  }

  AvailableVarients(var v, int index) {
    return GestureDetector(
      onTap: () {
        print("value_id: " + v["values"][index]["id"].toString());
        print("varient_id: " + v["id"].toString());

        setState(() {
          varientID = v["id"];
          varientTap = index;
          tapped = true;
          for (var i = 0; i < arrData.length; i++) {
            var map = arrData[i];

            if (map["variantCombinations"][index]["value"]["_id"] ==
                    v["values"][index]["id"] &&
                map["variantCombinations"][1]["value"]["_id"] ==
                    v["values"][index]["id"]) {
              print(map["_id"].toString());

              // var arrSubvarient =
              //     map["variantCombinations"][1]["value"]["name"].toString();
              // print(arrSubvarient);
            } else {
              print("not available");
            }
          }
        });
      },
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                  color: varientTap == index ? darkPink : Colors.white,
                  width: 2),
              borderRadius: BorderRadius.circular(3),
              color: Colors.grey[300]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child:
                Text(v["values"][index]["name"].toString(), style: size14_600),
          )),
    );
  }
}
