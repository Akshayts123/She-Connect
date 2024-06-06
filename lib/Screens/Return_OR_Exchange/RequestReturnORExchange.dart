import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/BottomNav.dart';

import '../../API/cancelOrderAPI.dart';

class RqstReturnOrExchange extends StatefulWidget {
  final txt;
  final id;
  final data;
  final Function refresh;
  RqstReturnOrExchange(
      {Key? key, this.txt, this.id, required this.refresh, this.data})
      : super(key: key);

  @override
  _RqstReturnOrExchangeState createState() => _RqstReturnOrExchangeState();
}

class _RqstReturnOrExchangeState extends State<RqstReturnOrExchange> {
  String dropdownvalue = 'Reason';

  var items = [
    'Reason',
    'Quality Issue',
    'Wrong color',
  ];
  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  int _n = 0;

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
        backgroundColor: BGgrey,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              )),
          title: Column(
            children: [
              Text(
                "Request " + widget.txt.toString(),
                style: appBarTxtStyl,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: productDetail(),
              )),
          h(10),
          Container(
            color: Colors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter " + widget.txt + " Details", style: size16_700),
                  h(5),
                  widget.txt == "Cancellation"
                      ? const Opacity(opacity: 0)
                      : Text("Select Quantity to " + widget.txt,
                          style: size14_600),
                  widget.txt == "Cancellation"
                      ? const Opacity(opacity: 0)
                      : h(10),
                  widget.txt == "Cancellation"
                      ? const Opacity(opacity: 0)
                      : incDecButton(),
                  h(15),
                  ReasonDropdown(),
                  h(15),
                  Comments(),
                  h(50),
                ],
              ),
            ),
          ),
          h(5),
          Container(
              color: Colors.white,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(children: [
                    widget.txt == "Return" || widget.txt == "Cancellation"
                        ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                                "Refund for pre-paid orders will be inititated instantly and will reflect within a maximum of 5-7 business days.",
                                textAlign: TextAlign.center,
                                style: size12_400Grey))
                        : const Opacity(opacity: 0),
                    h(20),
                    GestureDetector(
                        onTap: () async {
                          widget.txt == "Cancellation"
                              ? alert()
                              // cancelOrder()
                              // SuccessPop()
                              : null;
                        },
                        child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: darkPink)),
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text("Request " + widget.txt,
                                    style: size18_400Pink))))
                  ])))
        ])));
  }

  productDetail() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => SizedBox(
            height: 10,
          ),
          shrinkWrap: true,
          itemCount: widget.data["orderDetails"] != null
              ? widget.data["orderDetails"].length
              : 0,
          itemBuilder: (context, index) {
            final item = widget.data["orderDetails"] != null
                ? widget.data["orderDetails"][index]
                : null;

            return list(item, index);
          },
        ));
  }

  list(var item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
                image: DecorationImage(
                    image: NetworkImage(productCategoryImageURL +
                        item["product"]["image"].toString()),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["product"]["name"].toString(),
                    style: size16_700,
                  ),
                  // h(5),
                  // RichText(
                  //   text: const TextSpan(
                  //       text: 'Color:',
                  //       style: size10_600,
                  //       children: [TextSpan(text: '  RED', style: size10_600)]),
                  // ),
                  h(5),
                  Text("Qty: " + item["quantity"].toString(),
                      style: size14_700),
                  h(5),
                  Text(rs + item["netAmount"].toString(), style: size16_400)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Comments() {
    return Container(
        color: Colors.white,
        width: double.infinity,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
                color: textFieldGrey),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                    // controller: bodyController,
                    cursorColor: Colors.black,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    autofocus: false,
                    maxLength: 200,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: size14_400Grey,
                        hintText: "Comments (Optional)",
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none)))));
  }

  void SuccessPop() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(12)),
            elevation: 10,
            // title: Text('Request Amount'),
            content: StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/Images/Icons/success.png",
                          width: 110,
                        ),
                        h(10),
                        const Text("Successfully Cancelled", style: size22_600),
                        h(10),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const BottomNav()));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    gradient: buttonGradient,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: darkPink)),
                                child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Text("Back to Home",
                                        style: size14_600W)))),
                        const SizedBox(height: 10),
                      ]);
                })));
  }

  ReasonDropdown() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: textFieldGrey),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButton(
                value: dropdownvalue,
                elevation: 1,
                dropdownColor: Colors.white,
                isExpanded: true,
                style: size16_700,
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down, size: 18),
                items: items.map((String items) {
                  return DropdownMenuItem(value: items, child: Text(items));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                })));
  }

  incDecButton() {
    return Container(
        height: 25,
        width: 100,
        child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              SizedBox(
                  height: 30,
                  width: 30,
                  child: GestureDetector(
                      onTap: () {
                        minus();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          child: const Icon(Icons.remove, size: 20)))),
              Text('$_n', style: size16_700),
              SizedBox(
                  height: 30,
                  width: 30,
                  child: GestureDetector(
                      onTap: () {
                        add();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          child: const Icon(Icons.add, size: 20))))
            ])));
  }

  void alert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
        elevation: 10,
        title: Text('Confirm cancel this order?', style: size16_700),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent, textStyle: size12_700W),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.red[400], textStyle: size12_700W),
            onPressed: () async {
              var rsp = await cancelOrderAPI(widget.id);
              if (rsp["status"].toString() == "success") {
                SuccessPop();
                showToastSuccess("Order cancelled!");
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
