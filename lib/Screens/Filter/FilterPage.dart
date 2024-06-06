import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Filter/DATA/listCategoriesFilterAPI.dart';

class FilterPage extends StatefulWidget {
  final Function ree;
  final Function reset;
  const FilterPage({Key? key, required this.ree, required this.reset})
      : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  TextEditingController minController = new TextEditingController();
  TextEditingController maxController = new TextEditingController();
  RangeValues _currentRangeValues = const RangeValues(40, 80);
  int _selectedIndex = 0;
  var load = true;
  var arrCatData;
  var groupValue;
  var priceGroupValue;
  var ratingGroupValue;
  var catID;
  var priceRangeLow;
  var selectedRating;
  var priceRangeHigh;
  var minPrice;
  var maxPrice;
  var arrReturnData;
  var priceRadioValue = 0;
  var priceValuee = 0;
  var priceList = [
    {
      'name': rs + "99 and below",
      "low": 0,
      "high": 99,
    },
    {
      'name': rs + '100 to ' + rs + "299",
      "low": 100,
      "high": 299,
    },
    {
      'name': rs + '300 to ' + rs + "499",
      "low": 300,
      "high": 499,
    },
    {
      'name': rs + '500 to ' + rs + "699",
      "low": 500,
      "high": 699,
    },
    {
      'name': rs + '700 to ' + rs + "899",
      "low": 700,
      "high": 899,
    },
    {
      'name': rs + '900 to ' + rs + "1099",
      "low": 900,
      "high": 1099,
    },
    {
      'name': rs + '1100 to ' + rs + "1299",
      "low": 1100,
      "high": 1299,
    },
    {
      'name': rs + '1300 to ' + rs + "1499",
      "low": 1300,
      "high": 1499,
    },
    {
      'name': rs + "1500 and above",
      "low": 1500,
      "high": "",
    },
  ];

  var arrratingList = [
    {"count": "1", "name": "1 and above"},
    {"count": "2", "name": "2 and above"},
    {"count": "3", "name": "3 and above"},
    {"count": "4", "name": "4 and above"},
    {"count": "5", "name": "5 and above"},
  ];
  @override
  void initState() {
    super.initState();
    this.getNoti();
    setState(() {});
  }

  Future<String> getNoti() async {
    var rsp = await listCats();
    if (rsp["status"].toString() == "success") {
      setState(() {
        arrCatData = rsp["data"]["lists"];
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
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            )),
        title: Text(
          "Filter",
          style: appBarTxtStyl,
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: NavigationRail(
              backgroundColor: textFieldGrey,
              minWidth: 40,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              selectedLabelTextStyle: size16_700,
              elevation: 5,
              destinations: const [
                NavigationRailDestination(
                    icon: SizedBox.shrink(), label: Text('Category')),
                NavigationRailDestination(
                    icon: SizedBox.shrink(), label: Text('Price')),
                NavigationRailDestination(
                    icon: SizedBox.shrink(), label: Text('Discount')),
                NavigationRailDestination(
                    icon: SizedBox.shrink(), label: Text('Rating')),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
              flex: 2,
              child: _selectedIndex == 0
                  ? Container(
                      child: load == true
                          ? loading()
                          : ListView.separated(
                              scrollDirection: Axis.vertical,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 0),
                              shrinkWrap: true,
                              itemCount:
                                  arrCatData != null ? arrCatData.length : 0,
                              itemBuilder: (context, index) {
                                final item = arrCatData != null
                                    ? arrCatData[index]
                                    : null;

                                return CategoryList(item, index);
                              },
                            ),
                    )
                  : _selectedIndex == 1
                      ? Scrollbar(
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 0),
                            shrinkWrap: true,
                            itemCount: priceList != null ? priceList.length : 0,
                            itemBuilder: (context, index) {
                              final item =
                                  priceList != null ? priceList[index] : null;
                              return priceRangeList(item, index);
                            },
                          ),
                        )
                      : _selectedIndex == 2
                          ? Container(
                              color: Colors.white,
                              child: const Center(child: Text("Discount")),
                            )
                          : Scrollbar(
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 0),
                                shrinkWrap: true,
                                itemCount: arrratingList != null
                                    ? arrratingList.length
                                    : 0,
                                itemBuilder: (context, index) {
                                  final item = arrratingList != null
                                      ? arrratingList[index]
                                      : null;
                                  return ratingRangeList(item, index);
                                },
                              ),
                            ))
        ],
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefrences =
                        await SharedPreferences.getInstance();
                    Navigator.pop(context);
                    prefrences.remove(CATID);
                    prefrences.remove(PRICELOW);
                    prefrences.remove(PRICEHIGH);
                    prefrences.remove(RATING);
                    widget.reset();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: darkPink)),
                    child: const Text("Reset", style: size16_600pink),
                  ),
                ),
              ),
              w(20),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () async {
                    if (catID != null &&
                        priceRangeLow == null &&
                        selectedRating == null) {
                      await setSharedPrefrence(CATID, catID);
                      Navigator.pop(context);
                      widget.ree();
                    }
                    if (priceRangeLow != null &&
                        catID == null &&
                        selectedRating == null) {
                      await setSharedPrefrence(
                          PRICELOW, priceRangeLow.toString());
                      await setSharedPrefrence(
                          PRICEHIGH, priceRangeHigh.toString());
                      widget.ree();
                      Navigator.pop(context);
                    }
                    if (selectedRating != null &&
                        priceRangeLow == null &&
                        catID == null) {
                      await setSharedPrefrence(RATING, selectedRating);
                      widget.ree();
                      Navigator.pop(context);
                    }
                    if (catID != null &&
                        selectedRating != null &&
                        priceRangeLow != null &&
                        priceRangeHigh != null) {
                      await setSharedPrefrence(CATID, catID);
                      await setSharedPrefrence(
                          PRICELOW, priceRangeLow.toString());
                      await setSharedPrefrence(
                          PRICEHIGH, priceRangeHigh.toString());
                      await setSharedPrefrence(RATING, selectedRating);
                      widget.ree();
                      Navigator.pop(context);
                    }
                    if (catID != null &&
                        priceRangeHigh != null &&
                        priceRangeLow != null &&
                        selectedRating == null) {
                      await setSharedPrefrence(
                          PRICELOW, priceRangeLow.toString());
                      await setSharedPrefrence(
                          PRICEHIGH, priceRangeHigh.toString());
                      await setSharedPrefrence(CATID, catID);
                      widget.ree();
                      Navigator.pop(context);
                    }
                    if (catID != null &&
                        priceRangeLow == null &&
                        priceRangeHigh == null &&
                        selectedRating != null) {
                      await setSharedPrefrence(CATID, catID);
                      await setSharedPrefrence(RATING, selectedRating);
                      widget.ree();
                      Navigator.pop(context);
                    }
                    if (catID == null &&
                        priceRangeHigh != null &&
                        priceRangeLow != null &&
                        selectedRating != null) {
                      await setSharedPrefrence(
                          PRICELOW, priceRangeLow.toString());
                      await setSharedPrefrence(
                          PRICEHIGH, priceRangeHigh.toString());
                      await setSharedPrefrence(RATING, selectedRating);
                      widget.ree();
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: buttonGradient,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: darkPink)),
                    child: const Text("Apply Filter", style: size16_600W),
                  ),
                ),
              )
            ],
          ),
        ),
        color: Colors.white,
        height: 60,
      ),
    );
  }

  CategoryList(var item, int index) {
    return GestureDetector(
      onTap: () {
        handleRadioValueChanged(index);
      },
      child: Container(
          child: Row(children: [
        Radio(
            value: index,
            autofocus: false,
            groupValue: groupValue,
            activeColor: darkPink,
            onChanged: handleRadioValueChanged),
        Text(item["name"].toString(), style: size14_400)
      ])),
    );
  }

  void handleRadioValueChanged(value) {
    setState(() {
      groupValue = value;
      catID = arrCatData[value]["_id"].toString();
    });
  }

  priceRangeList(var item, int index) {
    return GestureDetector(
      onTap: () {
        handlePriceRangeChange(index);
      },
      child: Container(
          child: Row(children: [
        Radio(
            value: index,
            autofocus: false,
            groupValue: priceGroupValue,
            activeColor: darkPink,
            onChanged: handlePriceRangeChange),
        Text(item["name"].toString(), style: size14_400)
      ])),
    );
  }

  void handlePriceRangeChange(value) {
    setState(() {
      priceGroupValue = value;
      priceRangeLow = priceList[value]["low"];
      priceRangeHigh = priceList[value]["high"];
    });
  }

  ratingRangeList(var item, int index) {
    return Row(
      children: [
        Radio(
            value: index,
            autofocus: false,
            groupValue: ratingGroupValue,
            activeColor: darkPink,
            onChanged: handleRatingRangeChange),
        Icon(Icons.star, size: 13, color: Colors.black87),
        w(3),
        Text(item["name"].toString()),
      ],
    );
  }

  void handleRatingRangeChange(value) {
    setState(() {
      ratingGroupValue = value;
      selectedRating = arrratingList[value]["count"];
    });
  }
}
