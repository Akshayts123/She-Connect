import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:she_connect/API/addAddress_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';

class AddNewAddress extends StatefulWidget {
  final name;
  final mob;
  final Function refresh;
  const AddNewAddress({Key? key, required this.refresh, this.name, this.mob})
      : super(key: key);

  @override
  _AddNewAddressState createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  var adressType = "HOME";
  bool isCheck = true;

  @override
  void initState() {
    super.initState();
    getLocation();
    print(widget.name);

    setState(() {
      nameController.text = widget.name.toString();
      numberController.text = widget.mob.toString();
    });
  }

  void getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      printLocation();
    } else {
      requestPermission();
    }
  }

  requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      printLocation();
    } else {
      requestPermission();
    }
  }

  printLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10));
    print(position);
  }

  TextEditingController numberController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController pincodeController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController localityController = new TextEditingController();
  TextEditingController buildingController = new TextEditingController();
  TextEditingController landmarkController = new TextEditingController();

  int? _groupValue;
  var btTap = false;
  int _selectedIndex = 1;

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
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              )),
          title: const Text(
            "Add New Address",
            style: appBarTxtStyl,
          ),
        ),
        body: LayoutBuilder(builder: (context, snapshot) {
          if (snapshot.maxWidth < 600) {
            return SingleChildScrollView(
                child: Wrap(
              runSpacing: 10,
              children: [
                _contactDetails(),
                _addressInfo(),
                _addressType(),
                GestureDetector(
                  onTap: () async {
                    if (nameController.text.isNotEmpty &&
                        numberController.text.isNotEmpty &&
                        localityController.text.isNotEmpty &&
                        numberController.text.length == 10 &&
                        pincodeController.text.length == 6 &&
                        cityController.text.isNotEmpty &&
                        stateController.text.isNotEmpty &&
                        // landmarkController.text.isNotEmpty &&
                        pincodeController.text.isNotEmpty &&
                        buildingController.text.isNotEmpty) {
                      setState(() {
                        btTap = true;
                      });
                      var rsp = await addAddressAPI(
                          nameController.text.toString(),
                          numberController.text.toString(),
                          localityController.text.toString(),
                          cityController.text.toString(),
                          stateController.text.toString(),
                          pincodeController.text.toString(),
                          buildingController.text.toString(),
                          landmarkController.text.toString(),
                          adressType,
                          isCheck);
                      print(rsp);
                      if (rsp["status"].toString() == "success") {
                        widget.refresh();
                        showToastSuccess("Address added!");
                        Navigator.pop(context);
                        setState(() {
                          btTap = false;
                        });
                      } else {
                        showToastError(
                            "Something went wrong, PLease check the fields and verify!");
                        setState(() {
                          btTap = false;
                        });
                      }
                    } else {
                      showToastError("Please enter the required fields!");
                    }
                  },
                  child: Container(
                    // height: 50,
                    color: Colors.white,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          gradient: buttonGradient,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        child: btTap == true
                            ? SpinKitThreeBounce(
                                color: Colors.white,
                                size: 18,
                              )
                            : Text(
                                "SAVE ADDRESS",
                                style: size16_700W,
                              ),
                      ),
                    ),
                  ),
                )
              ],
            ));
          } else {
            return SingleChildScrollView(
                child: Wrap(
              runSpacing: 10,
              children: [
                _contactDetailsTab(),
                _addressInfoTab(),
                _addressType(),
                Container(
                  // height: 50,
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.3,
                        vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: buttonGradient,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      child: Text(
                        "SAVE ADDRESS",
                        style: size16_700W,
                      ),
                    ),
                  ),
                )
              ],
            ));
          }
        }));
  }

  _contactDetails() {
    return Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("CONTACT DETAILS", style: size14_700),
              const SizedBox(height: 25),
              TextFormField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: "Name*",
                      labelStyle: size14_400Grey,
                      filled: true,
                      fillColor: textFieldGrey,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: textFieldGrey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: textFieldGrey, width: 2.0)))),
              _gap(15),
              TextFormField(
                  controller: numberController,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Phone Number*",
                      labelStyle: size14_400Grey,
                      filled: true,
                      prefixText: "+91  ",
                      prefixStyle: size16_400,
                      fillColor: textFieldGrey,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: textFieldGrey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: textFieldGrey, width: 2.0))))
            ])));
  }

  _contactDetailsTab() {
    return Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("CONTACT DETAILS", style: size14_700),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: "Name*",
                            labelStyle: size14_400Grey,
                            filled: true,
                            fillColor: textFieldGrey,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: textFieldGrey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: textFieldGrey, width: 2.0)))),
                  ),
                  w(20),
                  Expanded(
                    child: TextFormField(
                        controller: numberController,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Phone Number*",
                            labelStyle: size14_400Grey,
                            filled: true,
                            fillColor: textFieldGrey,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: textFieldGrey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: textFieldGrey, width: 2.0)))),
                  )
                ],
              ),
            ])));
  }

  _addressInfo() {
    return Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("ADDRESS INFO", style: size14_700),
              const SizedBox(height: 25),
              Row(children: [
                Expanded(
                    child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(6)],
                        controller: pincodeController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Pincode*",
                            labelStyle: size14_400Grey,
                            filled: true,
                            fillColor: textFieldGrey,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: textFieldGrey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: textFieldGrey, width: 2.0))))),
                const SizedBox(width: 10),
                Expanded(
                    child: TextFormField(
                        controller: cityController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: "City*",
                            labelStyle: size14_400Grey,
                            filled: true,
                            fillColor: textFieldGrey,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: textFieldGrey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: textFieldGrey, width: 2.0)))))
              ]),
              _gap(15),
              TextFormField(
                  controller: stateController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: "State*",
                      labelStyle: size14_400Grey,
                      filled: true,
                      fillColor: textFieldGrey,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: textFieldGrey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: textFieldGrey, width: 2.0)))),
              _gap(15),
              TextFormField(
                  controller: localityController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: "Locality / Area / Street*",
                      labelStyle: size14_400Grey,
                      filled: true,
                      fillColor: textFieldGrey,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: textFieldGrey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: textFieldGrey, width: 2.0)))),
              _gap(15),
              TextFormField(
                  controller: buildingController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: "Flat No / Building or House name*",
                      labelStyle: size14_400Grey,
                      filled: true,
                      fillColor: textFieldGrey,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: textFieldGrey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: textFieldGrey, width: 2.0)))),
              _gap(15),
              TextFormField(
                  controller: landmarkController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      labelText: "Landmark",
                      labelStyle: size14_400Grey,
                      filled: true,
                      fillColor: textFieldGrey,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: textFieldGrey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: textFieldGrey, width: 1.0)))),
              _gap(15)
            ])));
  }

  _addressInfoTab() {
    return Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("ADDRESS INFO", style: size14_700),
              const SizedBox(height: 25),
              Row(children: [
                Expanded(
                    child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(6)],
                        controller: pincodeController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Pincode*",
                            labelStyle: size14_400Grey,
                            filled: true,
                            fillColor: textFieldGrey,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: textFieldGrey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: textFieldGrey, width: 2.0))))),
                const SizedBox(width: 20),
                Expanded(
                    child: TextFormField(
                        controller: cityController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: "City*",
                            labelStyle: size14_400Grey,
                            filled: true,
                            fillColor: textFieldGrey,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: textFieldGrey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: textFieldGrey, width: 2.0)))))
              ]),
              _gap(15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: stateController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: "State*",
                            labelStyle: size14_400Grey,
                            filled: true,
                            fillColor: textFieldGrey,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: textFieldGrey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: textFieldGrey, width: 2.0)))),
                  ),
                  w(20),
                  Expanded(
                    child: TextFormField(
                        controller: localityController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: "Locality / Area / Street*",
                            labelStyle: size14_400Grey,
                            filled: true,
                            fillColor: textFieldGrey,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: textFieldGrey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: textFieldGrey, width: 2.0)))),
                  ),
                ],
              ),
              _gap(15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: buildingController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: "Flat No / Building Name*",
                            labelStyle: size14_400Grey,
                            filled: true,
                            fillColor: textFieldGrey,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: textFieldGrey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: textFieldGrey, width: 2.0)))),
                  ),
                  w(20),
                  Expanded(
                    child: TextFormField(
                        controller: landmarkController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            labelText: "Landmark",
                            labelStyle: size14_400Grey,
                            filled: true,
                            fillColor: textFieldGrey,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: textFieldGrey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: textFieldGrey, width: 1.0)))),
                  )
                ],
              ),
            ])));
  }

  void buttonValue(int v) {
    setState(() {
      _selectedIndex = v;
    });
  }

  _addressType() {
    return Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "TYPE OF ADDRESS",
                style: size14_700,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(children: [
                  Radio<int>(
                      groupValue: _selectedIndex,
                      activeColor: radioClr,
                      // toggleable: true,
                      value: 1,
                      onChanged: (value) {
                        setState(() {
                          adressType = "Home".toUpperCase();
                          buttonValue(value!);
                          print(adressType);
                        });
                      }),
                  Text("Home", style: size16_400)
                ]),
                w(20),
                Row(children: [
                  Radio<int>(
                      groupValue: _selectedIndex,
                      activeColor: radioClr,
                      value: 2,
                      onChanged: (value) {
                        setState(() {
                          adressType = "Office".toUpperCase();
                          buttonValue(value!);

                          print(adressType);
                        });
                      }),
                  Text("Office", style: size16_400)
                ]),
                w(20),
                Row(children: [
                  Radio<int>(
                      groupValue: _selectedIndex,
                      activeColor: radioClr,
                      // toggleable: true,
                      value: 3,
                      onChanged: (value) {
                        setState(() {
                          adressType = "Other".toUpperCase();
                          buttonValue(value!);

                          print(adressType);
                        });
                      }),
                  Text("Other", style: size16_400)
                ])
              ]),
              CheckboxListTile(
                title:
                    const Text("Make default address", style: size14_400Grey),
                value: isCheck,
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.green,
                dense: true,
                onChanged: (newValue) {
                  setState(() {
                    isCheck = !isCheck;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              )
            ])));
  }

  radioType(String txt, setModelState) {
    return Row(children: [
      Radio<int>(
          groupValue: _selectedIndex,
          activeColor: radioClr,
          toggleable: true,
          value: 1,
          onChanged: (value) {
            setModelState() {
              print(value);
              _selectedIndex = value!;
            }
          }),
      Text(txt, style: size16_400)
    ]);
  }

  _gap(double h) {
    return SizedBox(height: h);
  }
}
