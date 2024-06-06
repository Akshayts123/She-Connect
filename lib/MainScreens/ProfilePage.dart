import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she_connect/API/userProfile_api.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/MainWidgets/shimmer.dart';
import 'package:she_connect/Screens/Address/SelectAddress.dart';
import 'package:she_connect/Screens/Chat/ChatListScreen.dart';
import 'package:she_connect/Screens/Login_Register/login.dart';
import 'package:she_connect/Screens/OrderHistory.dart';
import 'package:she_connect/Screens/ProfilePageScreens/Help&Support.dart';
import 'package:she_connect/Screens/ProfilePageScreens/returnRefundPolicy.dart';
import 'package:she_connect/Screens/ProfilePageScreens/termsN_Conditions.dart';
import 'package:she_connect/Screens/ProfilePageScreens/whoWeAre.dart';
import 'package:she_connect/Screens/ReferAFriend/ReferAFriend.dart';
import 'package:she_connect/Screens/UpdateProfile.dart';
import 'package:she_connect/Screens/Wallet/WalletScreen.dart';
import 'package:she_connect/Screens/WishlistScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Timer _timer;

  var arrDetails;
  var name;
  var email;
  var profilePic;
  var phone;
  var isLoading = true;
  var _image;
  var imgLoad = false;
  File? image;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    this.details();
    setState(() {});
  }

  Future<String> details() async {
    var rsp = await userprofile();
    print("--------------------");
    print(rsp);
    print("--------------------");
    if (rsp != 0) {
      setState(() {
        arrDetails = rsp["data"];
        name = arrDetails['name'].toString();
        email = arrDetails['email'].toString();
        phone = arrDetails['phone'].toString();
        profilePic = arrDetails['imageUrl'].toString();
      });
    }
    setState(() {
      isLoading = false;
      imgLoad = false;
    });
    return "success";
  }

  reee() async {
    var rsp = await userprofile();

    setState(() {
      if (rsp != 0) {
        setState(() {
          arrDetails = rsp["data"];
          name = arrDetails['name'].toString();
          email = arrDetails['email'].toString();
          phone = arrDetails['phone'].toString();
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    }
    if (hour < 17) {
      return 'Good Afternoon,';
    }
    return 'Good Evening,';
  }

  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      uploadImage();
      setState(() {
        imgLoad = true;
        details();
      });
    } else {
      print("error");
    }
  }

  Future getImageCam() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 1000,
        maxWidth: 1000);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      uploadImage();
      setState(() {
        imgLoad = true;

        details();
      });
    } else {
      print("error");
    }
  }

  Future<void> uploadImage() async {
    var img = image;
    var stream = new http.ByteStream(img!.openRead());
    stream.cast();
    var length = await img.length();
    var uri = Uri.parse(baseUrl + uploadProfilePic);
    var request = http.MultipartRequest("POST", uri);
    request.headers
        .addAll({'accept': '*/*', 'Content-Type': 'multipart/form-data'});
    var idd = await getSharedPrefrence(ID);
    request.fields["id"] = idd;
    var multiport = new http.MultipartFile("file", stream, length,
        filename: basename(img.path));
    request.files.add(await multiport);
    var rsp = await request.send();
    var rspd = await http.Response.fromStream(rsp);
    final rspData = json.decode(json.encode(rspd.body));
    print("oxoxoxoxoxoxoxoxoxoxoxoxoxoxoxxo");

    print("rspdata: " + rspData);
    print("oxoxoxoxoxoxoxoxoxoxoxoxoxoxoxxo");
    // print(rspd);
    if (rsp.statusCode == 201) {
      details();

      print("image uploaded!");
    } else {
      print("failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.1),
        child: AppBar(elevation: 0, backgroundColor: Color(0xffF9F9F9)),
      ),
      body: RefreshIndicator(
        onRefresh: details,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                color: Color(0xffF9F9F9),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 35, top: 35),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          isLoading == true
                              ? Text(greeting() + "\n" + "loading..",
                                  style: size22_600)
                              : Text(greeting() + "\n" + name.toString(),
                                  style: size22_600),
                          Spacer(),
                          isLoading == true
                              ? shimmerProfilePage()
                              : Stack(
                                  children: [
                                    imgLoad == true
                                        ? Container(
                                            alignment: Alignment.center,
                                            height: 100,
                                            width: 100,
                                            child: CircularProgressIndicator(),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                        : Container(
                                            child: arrDetails["imageUrl"] ==
                                                    null
                                                ? Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: Image.asset(
                                                          "assets/Images/Icons/profile.png",
                                                          fit: BoxFit.cover,
                                                        ).image)),
                                                    // child: Image.asset(
                                                    //     "assets/Images/Icons/profile.png"),
                                                  )
                                                : Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                arrDetails[
                                                                        "imageUrl"]
                                                                    .toString()),
                                                            fit: BoxFit.cover)),
                                                  ),
                                          ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          _openImagePicker(context);
                                        },
                                        child: CircleAvatar(
                                            backgroundColor: darkPink,
                                            radius: 18,
                                            child: Icon(Icons.camera_alt,
                                                size: 16)),
                                      ),
                                    )
                                  ],
                                )
                        ],
                      ),
                      isLoading == true
                          ? Text("loading..")
                          : Text("+91 " + phone.toString(),
                              style: size14_400Grey),
                      isLoading == true
                          ? Text("Loading..")
                          : Text(email.toString(), style: size14_400Grey),
                      h(10),
                      editButton(), // loginButton(),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  profileTiles("Orders", Icons.list_alt, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderHistory()),
                    );
                  }),
                  div(),
                  ListTile(
                    tileColor: Colors.white,
                    title: const Text(
                      "Wallet",
                      style: size16_400,
                    ),
                    leading: const Icon(FontAwesomeIcons.wallet, size: 20),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WalletScreen()),
                      );
                    },
                  ),
                  div(),
                  profileTiles("Refer a friend", Icons.person_add_outlined, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReferAFriend()),
                    );
                  }),
                  div(),
                  profileTiles("Wishlist", Icons.favorite_border, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Wishlist()),
                    );
                  }),
                  div(),
                  profileTiles("Addresses", Icons.location_on_outlined, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SelectAddress(name: name, mob: phone)),
                    );
                  }),
                  div(),
                  profileTiles("My Chats", Icons.chat_bubble_outline, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatListScreen()));
                  }),
                  Divider(thickness: 15, color: Color(0xffF9F9F9)),
                  profileTiles("Help and Support", Icons.help_outline, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => helpNSupport()),
                    );
                  }),
                  profileTiles(
                      "Terms & Conditions", Icons.insert_drive_file_outlined,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => termsN_Conditions()),
                    );
                  }),
                  profileTiles(
                      "Return & Refund Policy", Icons.keyboard_return_outlined,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => returnRefundPolicy()),
                    );
                  }),
                  ListTile(
                    tileColor: Colors.white,
                    title: Text("Who we are", style: size16_400),
                    leading: Icon(Icons.info_outline),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => whoWeAre()),
                      );
                    },
                  ),
                  // profileTiles("Who we are", Icons.info_outline, () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => whoWeAre()),
                  //   );
                  // }),
                  div(),
                  logoutButton()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  editButton() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            this.context,
            MaterialPageRoute(
                builder: (context) => UpdateProfile(
                    refresh: reee,
                    name: name.toString(),
                    mob: phone.toString(),
                    email: email)),
          );
        },
        child: Text("Edit", style: size16_600pink));
  }

  profileTiles(String title, IconData icon, GestureTapCallback ontap) {
    return ListTile(
      tileColor: Colors.white,
      title: Text(title, style: size16_400),
      leading: Icon(icon),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18),
      onTap: () {
        ontap();
      },
    );
  }

  div() {
    return Container(
      height: 1,
      color: Colors.grey[300],
      margin: EdgeInsets.symmetric(horizontal: 15),
    );
  }

  loginButton() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Login or Signup", style: size16_600pink),
            w(10),
            Icon(Icons.arrow_forward_ios_rounded, color: darkPink, size: 15)
          ],
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: darkPink),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  logoutButton() {
    return GestureDetector(
      onTap: () {
        _showDialog();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 30),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(this.context).size.width * 0.3,
              vertical: 8),
          child: const Text(
            "Logout",
            style: size16_600pink,
          ),
        ),
        decoration: BoxDecoration(
            color: Color(0xffF9F9F9),
            border: Border.all(color: darkPink),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Future<bool> _onBackPressed() async {
  //
  //   _showDialog();
  //
  // }

  void _showDialog() {
    showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        title: const Text('Confirm logout?'),
        titleTextStyle: const TextStyle(
            fontSize: 16,
            letterSpacing: 0.6,
            color: Color(0xff333333),
            fontWeight: FontWeight.bold),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();
              print("logout");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 165.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Select Image",
                  style: size16_700,
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    print("camera");
                    getImageCam();
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        size: 25.0,
                        // color: themeColor,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                      ),
                      Text(
                        "Camera",
                        style: size14_600,
                      ),
                    ],
                  ),
                ),
                h(20),
                InkWell(
                  onTap: () async {
                    getImage();
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.image,
                        size: 25.0,
                        // color: themeColor,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                      ),
                      Text("Gallery", style: size14_600)
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  // _getImage(BuildContext context, ImageSource source) async {
  //   _picker.pickImage(
  //     source: source,
  //     imageQuality: 50,
  //     preferredCameraDevice: CameraDevice.front,
  //     maxWidth: 400.0,
  //     maxHeight: 400.0,
  //   );
  //   setState(() {
  //     _image = File(image!.path);
  //   });
  // }
}
