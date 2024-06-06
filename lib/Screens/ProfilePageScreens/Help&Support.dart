import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Const/Constants.dart';

class helpNSupport extends StatefulWidget {
  const helpNSupport({Key? key}) : super(key: key);

  @override
  _helpNSupportState createState() => _helpNSupportState();
}

class _helpNSupportState extends State<helpNSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    launchFB();
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FontAwesomeIcons.facebookF,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: darkPink),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchIG();
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FontAwesomeIcons.instagram,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: darkPink),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    yt();
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FontAwesomeIcons.youtube,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: darkPink),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    LinkedIn();
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FontAwesomeIcons.linkedin,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: darkPink),
                  ),
                ),
              ],
            )),
        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,
                    color: Colors.black, size: 25)),
            title: const Text("Help & Support", style: appBarTxtStyl)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  var url = 'tel:' + "+9199952384383";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    showToastError("Unable to ");
                    throw 'Could not launch $url';
                  }
                },
                child: Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.phone,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: darkPink),
                        ),
                        w(15),
                        Text("+91 99952 38438", style: size16_700)
                      ],
                    ),
                  ),
                ),
              ),
              h(10),
              GestureDetector(
                onTap: () {
                  openwhatsapp();
                },
                child: Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              FontAwesomeIcons.whatsapp,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: darkPink),
                        ),
                        w(15),
                        Text("+91 99952 38438", style: size16_700)
                      ],
                    ),
                  ),
                ),
              ),
              h(10),
              GestureDetector(
                onTap: () async {
                  var url = 'mailto:' + "sheconnect.clt@gmail.com";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    showToastSuccess("Unable to create mail");
                    throw 'Could not launch $url';
                  }
                },
                child: Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.email_outlined,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: darkPink),
                        ),
                        w(15),
                        Text("sheconnect.clt@gmail.com", style: size16_700)
                      ],
                    ),
                  ),
                ),
              ),
              h(20),
            ],
          ),
        ));
  }

  openwhatsapp() async {
    var whatsapp = "+919995238438";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("WhatsApp no installed!")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("WhatsApp no installed!")));
      }
    }
  }

  void launchFB() async {
    var url = 'https://www.facebook.com/she.connect.india/';
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
      );
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }

  void launchIG() async {
    var url = 'https://www.instagram.com/sheconnect/';
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
      );
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }

  void yt() async {
    var url = 'https://www.youtube.com/channel/UCJ0sIEyzU_GgY0cj4DjX53Q';
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
      );
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }

  void LinkedIn() async {
    var url = 'https://www.linkedin.com/company/sheconnect/';
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
      );
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }
}
