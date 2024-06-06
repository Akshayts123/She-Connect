import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';

class SheConnectHome extends StatefulWidget {
  const SheConnectHome({Key? key}) : super(key: key);

  @override
  _SheConnectHomeState createState() => _SheConnectHomeState();
}

class _SheConnectHomeState extends State<SheConnectHome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: liteGrey),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Wrap(
              runSpacing: 15,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "SHE CONNECT",
                  style: size30,
                ),
                Text(
                  txt,
                  style: size22_600,
                ),
                Text(
                  "SHE CONNECT",
                  style: size30,
                ),
                Text(
                  txt,
                  style: size22_600,
                ),
                Text(
                  "SHE CONNECT",
                  style: size30,
                ),
                Text(
                  txt,
                  style: size22_600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
