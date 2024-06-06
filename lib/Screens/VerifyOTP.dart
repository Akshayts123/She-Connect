import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:timer_button/timer_button.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({Key? key}) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              ))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Verify with OTP",
              style: size22_600,
            ),
            h(10),
            const Text(
              "Sent via SMS to 9734572837",
              style: size14_400Grey,
            ),
            h(40),
            otp(),
            resendOTP(),
            h(15),
            const Text(
              "Trouble getting OTP?",
              style: size18_700,
            ),
            h(10),
            const Text(
              "Make sure you entered correct mobile number.",
              style: size14_400Grey,
            )
          ],
        ),
      ),
    );
  }

  Widget resendOTP() {
    return SizedBox(
      height: 30,
      child: TimerButton(
        label: "Resend OTP",
        color: Colors.white, resetTimerOnPressed: true,
        // resetTimerOnPressed: true,
        buttonType: ButtonType.FlatButton,
        timeOutInSeconds: 5,
        onPressed: () async {
          // print("resend");
          // var rsp = await sendOtpApi(widget.mob.toString());
          // print("rsp['attributes']");
          // if (rsp['attributes']['message'].toString() ==
          //     "Success") {
          //   showToastSuccess("OTP Resented!");
          // }
        },
        disabledColor: Colors.red,
        // color: BlckColor,
        disabledTextStyle: const TextStyle(fontSize: 12.0, color: Colors.grey),
        activeTextStyle: size14_400Grey,
      ),
    );
  }

  otp() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: PinCodeTextField(
        appContext: context,
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
          borderWidth: 1,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 46,
          fieldWidth: 37,
        ),
        cursorColor: Colors.black54,
        cursorHeight: 20,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        autoFocus: true,
        autoDisposeControllers: false,
        keyboardType: TextInputType.number,
        onCompleted: (v) async {
          // setState(() {
          //   isTap = true;
          //   otpFail = false;
          // });
          // var rsp =
          //     await verifyOtpApi(widget.mob.toString(), otpController.text);
          //
          // print("rsp['attributes']");
          //
          // // Map valueMap = jsonDecode(rsp.toString());
          // print(rsp);
          //
          // if (rsp['attributes']['message'].toString() == "Success") {
          //   var rsp = await checkUserApi(widget.mob.toString());
          //
          //   if (rsp['attributes']['response'].toString() ==
          //       "Registered Customer") {
          //     var id = await setSharedPrefrence(
          //         ID, rsp['attributes']['studentInfo']['studentId']);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => HomeScreen()),
          //     );
          //   } else {
          //     // var id = await setSharedPrefrence(
          //     //     ID,
          //     //     rsp['attributes']['studentInfo']
          //     //     ['studentId']);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => EnterDetails(
          //                 mob: widget.mob.toString(),
          //               )),
          //     );
          //   }
          // } else if (rsp['attributes']['response'].toString() ==
          //     "Invalid OTP") {
          //   setState(() {
          //     otpFail = true;
          //   });
          // }
          //
          // setState(() {
          //   isTap = false;
          // });
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
