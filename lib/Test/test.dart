import 'package:flutter/material.dart';

import 'api.dart';

class SelectCatagoryList extends StatefulWidget {
  const SelectCatagoryList({Key? key}) : super(key: key);

  @override
  State<SelectCatagoryList> createState() => _SelectCatagoryListState();
}

class _SelectCatagoryListState extends State<SelectCatagoryList> {
  int _dropdownValue = 1;

  var arrDealsList;
  var prdID;
  var data;
  @override
  void initState() {
    super.initState();
    this.getHome();
    setState(() {});
  }

  Future<String> getHome() async {
    var rsp = await arrData;
    data = rsp;
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text(
      //     "",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   elevation: 0,
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.keyboard_backspace,
      //       color: Colors.black,
      //     ),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ),
      body: ListView.separated(
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => SizedBox(
          height: 10,
        ),
        shrinkWrap: true,
        itemCount: data != null ? data.length : 0,
        itemBuilder: (context, index) {
          final item = data != null ? data[index] : null;

          return list(item, index);
        },
      ),
    );
  }

  list(var item, int index) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(item["data"][0]["name"].toString())
          ], // children: [Text(item["data"]["name"].toString())],
        ),
      ),
    );
  }
}
