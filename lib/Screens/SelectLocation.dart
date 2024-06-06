import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({Key? key}) : super(key: key);

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BGgrey,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
              size: 18,
            )),
        title: const Text(
          "Select Location",
          style: appBarTxtStyl,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Current Operating Cities",
              style: size16_400grey,
            ),
            gap(15),
            Row(
              children: const [
                Text(
                  "Calicut",
                  style: size16_400,
                ),
                Spacer(),
                Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 18,
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Divider(
              color: Colors.grey,
            ),
            gap(20),
            const Text(
              "Coming soon in",
              style: size16_400grey,
            ),
            gap(15),
            ListView.separated(
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) => h(10),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return citiesList(index);
              },
            )
          ],
        ),
      ),
    );
  }

  gap(double h) {
    return SizedBox(
      height: h,
    );
  }

  citiesList(int index) {
    return const Text(
      "Cochin",
      style: size16_400,
    );
  }
}
