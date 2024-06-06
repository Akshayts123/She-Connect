import 'package:flutter/material.dart';

import '../../Const/Constants.dart';

class whoWeAre extends StatefulWidget {
  const whoWeAre({Key? key}) : super(key: key);

  @override
  _whoWeAreState createState() => _whoWeAreState();
}

class _whoWeAreState extends State<whoWeAre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon:
                  const Icon(Icons.arrow_back, color: Colors.black, size: 18)),
          title: const Text("Who we are", style: appBarTxtStyl)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
            child: Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
          style: size16_400,
        )),
      ),
    );
  }
}
