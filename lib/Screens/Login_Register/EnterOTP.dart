import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:she_connect/API/VerifyOTP_api.dart';
import 'package:she_connect/API/generateOTP_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/BottomNav.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_button/timer_button.dart';

import 'Register.dart';

class OTPScreen extends StatefulWidget {
  final mob;
  final hash;

  const OTPScreen({Key? key, @required this.mob, @required this.hash})
      : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = new TextEditingController();
  bool isTap = false;
  bool otpFail = false;
  var toooken;
  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 25,
                  )),
            ),
            bottomNavigationBar: SizedBox(
              height: 70,
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isTap = true;
                    otpFail = false;
                  });
                  var rsp = await verifyOTP(
                      widget.mob.toString(), otpController.text);
                  var tkkk = rsp["data"]["access_token"];
                  print("access token: " + tkkk.toString());
                  // print(rsp["data"]["user"]["_id"]);
                  var accessToken = await setSharedPrefrence(TOKEN, tkkk);
                  var id =
                      await setSharedPrefrence(ID, rsp["data"]["user"]["_id"]);
                  print("----------------otpp-----------------------");
                  if (rsp["status"].toString() == "success") {
                    if (rsp["data"]["user"]["name"] == null) {
                      print("new user");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Register(mob: widget.mob.toString())),
                      );
                    } else {
                      print("old user");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNav()),
                      );
                    }
                  } else {
                    print(rsp);
                    showToastError(rsp["error"].toString());
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: buttonGradient,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Continue",
                            style: size16_700W,
                          ),
                          w(5),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 14,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Verify With OTP",
                        style: size22_400, textAlign: TextAlign.left),
                  ),
                  h(5),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: RichText(
                      text: TextSpan(
                          text: 'Enter the OTP sent to  ',
                          style: size14_400Grey,
                          children: [
                            TextSpan(
                              text: "+91 " + '${widget.mob.toString()}',
                              style: size14_400Grey,
                            )
                          ]),
                    ),
                  ),
                  Center(
                    child: Lottie.asset("assets/Images/otp.json",
                        // repeat: false,
                        height: MediaQuery.of(context).size.height * 0.25),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 20),
                      //   child: Text(
                      //     "Enter the OTP sent to +91 ${widget.mob.toString()}, ",
                      //     style: TextStyle(
                      //         fontSize: 15,
                      //         color: Colors.black54,
                      //         fontWeight: FontWeight.w600,
                      //         fontFamily: 'Segoe'),
                      //   ),
                      // ),
                      h(20),
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.25,
                            left: 20),
                        // child: PinFieldAutoFill(
                        //   // cursor: Cursor(
                        //   //   width: 2,
                        //   //   height: 20,
                        //   //   color: Colors.black38,
                        //   //   // radius: Radius.circular(1),
                        //   //   enabled: true,
                        //   // ),
                        //   textInputAction: TextInputAction.done,
                        //   decoration: BoxLooseDecoration(
                        //       bgColorBuilder: PinListenColorBuilder(
                        //           textFieldGrey, textFieldGrey),
                        //       strokeColorBuilder: PinListenColorBuilder(
                        //           Colors.black, Colors.black54),
                        //       strokeWidth: 2,
                        //       textStyle: size16_700),
                        //   onCodeSubmitted: (v) async {
                        //     setState(() {
                        //       isTap = true;
                        //       otpFail = false;
                        //     });
                        //     var rsp = await verifyOTP(
                        //         widget.mob.toString(), otpController.text);
                        //     print("rspppppppppppppppppppp");
                        //     print(rsp);
                        //     print("rspppppppppppppppppppp");
                        //   },
                        //   onCodeChanged: (code) {
                        //     if (code?.length == 4) {
                        //       FocusScope.of(context).requestFocus(FocusNode());
                        //     }
                        //   },
                        //   enableInteractiveSelection: true,
                        //   codeLength: 4,
                        //   controller: otpController,
                        //   keyboardType: TextInputType.number,
                        //   autoFocus: true,
                        // ),
                      ),
                      otp(),
                      h(10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Trouble getting OTP?", style: size18_400),
                      ),
                      h(10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            "Make sure you entered correct mobile number.",
                            style: size14_400),
                      ),
                      h(15),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 30,
                          child: TimerButton(
                            label: "Resend OTP",
                            color: darkPink,
                            resetTimerOnPressed: true,
                            buttonType: ButtonType.TextButton,
                            timeOutInSeconds: 60,
                            onPressed: () async {
                              print("resend");
                              print(widget.mob.toString());
                              var rsp = await generateOTP(widget.mob.toString(),
                                  widget.hash.toString());
                              print("----------------");
                              print(rsp);
                              // if (rsp["status"].toString() == "success") {
                              //   showToastSuccess("OTP Resented!");
                              // } else {
                              //   if (rsp["error"].toString() ==
                              //       "User Otp Limit Exceeded For today") {
                              //     showToastError("errorrr");
                              //   }
                              // }
                            },
                            disabledColor: Colors.white,
                            // color: BlckColor,
                            disabledTextStyle: new TextStyle(
                                fontSize: 12.0, color: Colors.grey),
                            activeTextStyle: new TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )

                      // otp(),
                    ],
                  )
                ],
              ),
            ));
      } else {
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 25,
                  )),
            ),
            bottomNavigationBar: SizedBox(
              height: 70,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: buttonGradient,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Continue",
                            style: size16_700W,
                          ),
                          w(5),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 14,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Lottie.asset("assets/Images/otp.json",
                      // repeat: false,
                      height: MediaQuery.of(context).size.height * 0.2),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Enter the OTP sent to +91 ${widget.mob.toString()}, ",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Segoe'),
                      ),
                    ),
                    h(20),
                    PinFieldAutoFill(
                      cursor: Cursor(
                        width: 2,
                        height: 40,
                        color: Colors.black,
                        radius: Radius.circular(1),
                        enabled: true,
                      ),
                      decoration: UnderlineDecoration(
                        textStyle: TextStyle(fontSize: 20, color: Colors.black),
                        colorBuilder:
                            FixedColorBuilder(Colors.black.withOpacity(0.3)),
                      ),
                      onCodeSubmitted: (v) async {
                        setState(() {
                          isTap = true;
                          otpFail = false;
                        });
                        var rsp = await verifyOTP(
                            widget.mob.toString(), otpController.text);
                        print("rspppppppppppppppppppp");
                        print(rsp);
                      },
                      onCodeChanged: (code) {
                        if (code?.length == 4) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                      enableInteractiveSelection: true,
                      codeLength: 4,
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      autoFocus: true,
                    ),
                    // otpTablet(),
                  ],
                )
              ],
            ));
      }
    });
  }

  otp() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: PinCodeTextField(
        appContext: context,
        mainAxisAlignment: MainAxisAlignment.start,
        autovalidateMode: AutovalidateMode.always,
        backgroundColor: Colors.transparent,
        controller: otpController,
        length: 4,
        enablePinAutofill: true,
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        textStyle: const TextStyle(color: Color(0xff2F455C), fontSize: 18),
        pinTheme: PinTheme(
          inactiveFillColor: Colors.white,
          fieldOuterPadding: EdgeInsets.only(right: 8),
          activeFillColor: Colors.white,
          selectedFillColor: Colors.white,
          inactiveColor: Colors.black12,
          selectedColor: Colors.black45,
          activeColor: Colors.black,
          borderWidth: 3,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 50,
        ),
        cursorColor: Colors.black54,
        cursorHeight: 20,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        autoFocus: true,
        enabled: true,
        autoDisposeControllers: false,
        keyboardType: TextInputType.number,
        onCompleted: (v) async {
          setState(() {
            isTap = true;
            otpFail = false;
          });
          var rsp = await verifyOTP(widget.mob.toString(), otpController.text);
          print("---------------------------------------");
          if (rsp["status"].toString() == "success") {
            var tkkk = rsp["data"]["access_token"];
            // print(rsp["data"]["user"]["_id"]);
            var accessToken = await setSharedPrefrence(TOKEN, tkkk);
            print("access token: " + tkkk.toString());

            var id = await setSharedPrefrence(ID, rsp["data"]["user"]["_id"]);
            print("----------------otpp-----------------------");
            if (rsp["data"]["user"]["name"] == null) {
              print("new user");

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Register(mob: widget.mob.toString())),
              );
            } else {
              print("old user");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomNav()),
              );
            }
          } else {
            print(rsp);
            showToastError(rsp["error"].toString());
          }
        },
        onChanged: (code) {
          if (code.length == 4) {
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          return true;
        },
      ),
    );
  }

  void _listen() async {
    await SmsAutoFill().listenForCode;
  }

  otpTablet() {
    return Padding(
      padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.6, left: 20),
      child: PinCodeTextField(
        appContext: context,
        // mainAxisAlignment: MainAxisAlignment.,
        autovalidateMode: AutovalidateMode.always,
        backgroundColor: Colors.transparent,
        controller: otpController,
        length: 4,
        enablePinAutofill: true,
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        textStyle: const TextStyle(color: Color(0xff2F455C), fontSize: 18),
        pinTheme: PinTheme(
          inactiveFillColor: Colors.white,
          activeFillColor: Colors.white,
          selectedFillColor: Colors.white,
          inactiveColor: Colors.black12,
          selectedColor: Colors.black45,
          activeColor: Colors.black,
          borderWidth: 3,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 50,
        ),
        cursorColor: Colors.black54,
        cursorHeight: 20,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        autoFocus: true,
        autoDisposeControllers: false,

        keyboardType: TextInputType.number,
        onCompleted: (v) async {
          setState(() {
            isTap = true;
            otpFail = false;
          });
          var rsp = await verifyOTP(widget.mob.toString(), otpController.text);
          print("rspppppppppppppppppppp");
          print(rsp);
          print("rspppppppppppppppppppp");
        },
        onChanged: (value) {},
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          return true;
        },
      ),
    );
  }
}
