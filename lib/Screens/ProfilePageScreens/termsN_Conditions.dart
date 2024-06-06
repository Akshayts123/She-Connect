import 'package:flutter/material.dart';

import '../../Const/Constants.dart';

class termsN_Conditions extends StatefulWidget {
  const termsN_Conditions({Key? key}) : super(key: key);

  @override
  _termsN_ConditionsState createState() => _termsN_ConditionsState();
}

class _termsN_ConditionsState extends State<termsN_Conditions> {
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
          title: const Text("Terms & Condition", style: appBarTxtStyl)),
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
