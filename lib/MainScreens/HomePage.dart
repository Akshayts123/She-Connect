import 'package:flutter/material.dart';
import 'package:she_connect/Helper/sharedPref.dart';
import 'package:she_connect/Home_All_Widgets/HomeWidgets.dart';
import 'package:she_connect/Screens/Notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropdownvalue = 'Calicut';

  var items = ['Calicut', 'Ekm', 'Kollam'];

  @override
  Widget build(BuildContext context) {
    var tk = getSharedPrefrence(TOKEN);
    print(tk);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          // title: DropdownButton(
          //     value: dropdownvalue,
          //     elevation: 1,
          //     dropdownColor: Colors.white,
          //     style: size18_700,
          //     underline: Container(),
          //     icon: const Icon(Icons.keyboard_arrow_down),
          //     items: items.map((String items) {
          //       return DropdownMenuItem(value: items, child: Text(items));
          //     }).toList(),
          //     onChanged: (String? newValue) {
          //       setState(() {
          //         dropdownvalue = newValue!;
          //       });
          //     }),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage()));
                },
                icon: const Icon(Icons.notifications_none, color: Colors.black))
          ],
        ),
        body: Column(children: [
          HomeTabs(),
        ]));
  }
}
