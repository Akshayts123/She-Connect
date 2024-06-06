import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:she_connect/API/generateOTP_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../MainWidgets/BottomNav.dart';
import 'EnterOTP.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isTap = false;
  bool enableBttn = false;

  TextEditingController numberController = new TextEditingController();

  void enableTap() {
    setState(() {
      isTap = true;
    });
  }

  void disableTap() {
    setState(() {
      isTap = false;
    });
  }

  Future<bool> _onBackPressed() {
    SystemNavigator.pop();

    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: LayoutBuilder(builder: (context, snapshot) {
        if (snapshot.maxWidth < 600) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0.1),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: SvgPicture.asset("assets/logo.svg"),
                  ),
                  Text("Enter Your Phone Number", style: size18_700),
                  h(10),
                  Text("Please enter your phone number to sign in",
                      style: size14_400Grey),
                  h(20),
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                              keyboardType: TextInputType.number,
                              controller: numberController,
                              style: size16_700,
                              onChanged: (v) {
                                if (numberController.text.length == 10) {
                                  setState(() {
                                    enableBttn = true;
                                  });
                                }
                              },
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              decoration: InputDecoration(
                                  labelText: "Mobile Number",
                                  labelStyle: size14_400Grey,
                                  prefixText: "+91  ",
                                  prefixStyle: size16_700,
                                  filled: true,
                                  fillColor: textFieldGrey,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: textFieldGrey)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: textFieldGrey, width: 2.0)))),
                          h(10),
                          Text(
                              "By clicking, you agree to our terms and conditions.",
                              style: size12_400Grey),
                          h(20),
                          enableBttn == false
                              ? Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: buttonGradient,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      child: Text(
                                        "Login",
                                        style: size16_700W,
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    var phone =
                                        numberController.text.toString();
                                    if (phone.isNotEmpty &&
                                        phone.length == 10) {
                                      enableTap();
                                      final sign =
                                          await SmsAutoFill().getAppSignature;
                                      print(sign);
                                      var rsp = await generateOTP(
                                          numberController.text.toString(),
                                          sign.toString());
                                      print(rsp);
                                      if (rsp["status"].toString() ==
                                          "success") {
                                        final sign =
                                            await SmsAutoFill().getAppSignature;
                                        print(sign);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => BottomNav()),
                                        );
                                      }
                                      disableTap();
                                    } else {
                                      showToastError(
                                          "Please enter a valid mobile number");
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: buttonGradient,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      child: isTap == true
                                          ? SpinKitThreeBounce(
                                              color: Colors.white, size: 20)
                                          : Text(
                                              "Login",
                                              style: size16_700W,
                                            ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0.1),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(gradient: buttonGradient),
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image.asset(
                      "assets/Images/logo.jpg",
                    ),
                  ),
                  h(50),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.15,
                    ),
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40, horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextFormField(
                                keyboardType: TextInputType.number,
                                controller: numberController,
                                style: size16_700,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                decoration: InputDecoration(
                                    prefixText: "+91  ",
                                    prefixStyle: size16_700,
                                    labelText: "Mobile Number",
                                    labelStyle: size14_400Grey,
                                    filled: true,
                                    fillColor: textFieldGrey,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: textFieldGrey)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: textFieldGrey,
                                            width: 2.0)))),
                            h(30),
                            numberController.text.toString().length <= 9
                                ? Opacity(
                                    opacity: 0.5,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          gradient: buttonGradient,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15),
                                        child: Text(
                                          "Login",
                                          style: size16_700W,
                                        ),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      var phone =
                                          numberController.text.toString();
                                      if (phone.isNotEmpty &&
                                          phone.length == 10) {
                                        enableTap();
                                        final sign =
                                            await SmsAutoFill().getAppSignature;
                                        print(sign);
                                        var rsp = await generateOTP(
                                            numberController.text.toString(),
                                            sign);
                                        if (rsp["status"].toString() ==
                                            "success") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => OTPScreen(
                                                    mob: numberController.text
                                                        .toString(),
                                                    hash: sign.toString())),
                                          );
                                        }
                                        disableTap();
                                      } else {
                                        showToastError(
                                            "Please enter a valid mobile number");
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          gradient: buttonGradient,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15),
                                        child: isTap == true
                                            ? SpinKitWave(
                                                color: Colors.white, size: 20)
                                            : Text(
                                                "Login",
                                                style: size16_700W,
                                              ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
