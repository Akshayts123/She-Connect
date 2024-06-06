import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';

class PickupAddress extends StatefulWidget {
  const PickupAddress({Key? key}) : super(key: key);

  @override
  _PickupAddressState createState() => _PickupAddressState();
}

class _PickupAddressState extends State<PickupAddress> {
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
            title: Column(children: const [
              Text(
                "Select Pick Up Address",
                style: appBarTxtStyl,
              ),
              Text("Step 1 of 3", style: size12_400Grey)
            ])),
        body: SingleChildScrollView(
            child: Column(children: [
          ListView.separated(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (context, index) {
                return AddressList(index);
              }),
          GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>  AddNewAddress(refresh: reee,)));
              },
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Text("+ Add New Address", style: size14_600Pink))))
        ])),
        bottomNavigationBar: Container(
            height: 50,
            child: button(),
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10)));
  }

  button() {
    return GestureDetector(
        onTap: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const ExchngORReturn()));
        },
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: buttonGradient,
                borderRadius: BorderRadius.circular(10)),
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text("Proceed", style: size16_700W))));
  }

  AddressList(int index) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12)),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text("Home", style: size16_700),
                        const SizedBox(width: 10),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: green),
                            child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: Text("DEFAULT", style: size12_400W))),
                        const Spacer(),
                        Radio<int>(
                            groupValue: _groupValue,
                            activeColor: darkPink,
                            toggleable: true,
                            value: 1,
                            onChanged: (int? value) {
                              setState(() {
                                _groupValue = value;
                              });
                            })
                      ]),
                      const Text("Shankar", style: size14_600),
                      const SizedBox(height: 5),
                      const Text("Kozhippatta House, Paravur",
                          style: size14_400Grey),
                      const Text("Ernakulam", style: size14_400Grey),
                      const Text("Kerala, India - 683 562",
                          style: size14_400Grey),
                      const Text("Phone : 9893425994", style: size14_400Grey),
                      const Divider(color: darkPink),
                      const Text("Return pickup available",
                          style: size14_600Green),
                      h(5),
                      const Text("Exchange available", style: size14_600Green),
                    ]))));
  }
}
