import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:she_connect/API/FirebaseNotification_api.dart';
import 'package:she_connect/API/RegisterUser_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:she_connect/MainWidgets/BottomNav.dart';
import 'package:she_connect/main.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //   apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
      //   appId: '1:448618578101:ios:2bc5c1fe2ec336f8ac3efc',
      //   messagingSenderId: '448618578101',
      //   projectId: 'react-native-firebase-testing',
      // ),
      );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(const MyApp());
}

class Register extends StatefulWidget {
  final mob;
  const Register({Key? key, @required this.mob}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  var tokeenn;
  var idd;

  @override
  void initState() {
    HttpOverrides.global = new MyHttpOverrides();
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("aaaaaaaaaaaaaa");
      }
    });
    FirebaseMessaging.instance.getToken().then((value) async {
      idd = await getSharedPrefrence(ID);

      String? token = value;

      var rsp = await Notification_api(idd, token);
      print("_________Firebase__________");
      print(rsp);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print("bbbbbbbb");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // title: Text(
        //   "Register",
        //   style: appBarTxtStyl,
        // ),
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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SvgPicture.asset("assets/logo.svg"),
                h(20),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            name(),
                            h(20),
                            Email(),
                          ],
                        ),
                        h(30),
                        button()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget name() {
    return TextFormField(
        controller: nameController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            labelText: "Name",
            labelStyle: size14_400Grey,
            filled: true,
            fillColor: textFieldGrey,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: textFieldGrey)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: textFieldGrey, width: 2.0))));
  }

  Widget button() {
    return GestureDetector(
      onTap: () async {
        tokeenn = await getSharedPrefrence(TOKEN);
        if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
          var rsp = await updateProfile(nameController.text.toString(),
              emailController.text.toString(), widget.mob.toString());
          print(rsp);
          if (rsp["status"].toString() == "success") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomNav()),
            );
          } else {
            showToastSuccess("Something went wrong!");
          }
        } else {
          showToastError("Please fill the required fields!");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: buttonGradient,
              borderRadius: BorderRadius.circular(10)),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: Text(
              "Register",
              style: size16_700W,
            ),
          ),
        ),
      ),
    );
  }

  Widget Email() {
    return TextFormField(
        controller: emailController,
        validator: (value) => EmailValidator.validate(value!)
            ? null
            : "Please enter a valid email",
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: "Email",
            labelStyle: size14_400Grey,
            filled: true,
            fillColor: textFieldGrey,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: textFieldGrey)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: textFieldGrey, width: 2.0))));
  }
}
