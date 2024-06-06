import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';
import 'package:she_connect/Screens/TopOfferCategoryExpandedScreen.dart';

class Top4Cat extends StatefulWidget {
  const Top4Cat({Key? key}) : super(key: key);

  @override
  _Top4CatState createState() => _Top4CatState();
}

class _Top4CatState extends State<Top4Cat> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _catCircle(trndNow),
            _catCircle(bstSllr),
            _catCircle(sheTrust),
            _catCircle(newArr)
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _catCircleTablet(trndNow),
            _catCircleTablet(bstSllr),
            _catCircleTablet(sheTrust),
            _catCircleTablet(newArr)
          ],
        );
      }
    });
  }

  Widget _catCircle(String HeadTxt) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryExpandedPage(titlee: HeadTxt)));
        },
        child: Container(
            height: MediaQuery.of(context).size.height * 0.13,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Text(HeadTxt,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            fontFamily: 'Segoe'),
                        maxLines: 2,
                        textAlign: TextAlign.center))),
            decoration: BoxDecoration(
                color: darkPink,
                border: Border.all(
                  color: darkPink,
                ),
                shape: BoxShape.circle)));
  }

  Widget _catCircleTablet(String HeadTxt) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryExpandedPage(titlee: HeadTxt)));
        },
        child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.1,
            child: Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Text(HeadTxt,
                        style: TextStyle(
                            color: Colors.white,
                            // color: darkPink,
                            fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.width * 0.02,
                            fontFamily: 'Segoe'),
                        maxLines: 2,
                        textAlign: TextAlign.center))),
            decoration: BoxDecoration(
                color: darkPink,
                // color: liteGrey,
                border: Border.all(
                  color: darkPink,
                ),
                shape: BoxShape.circle)));
  }
}
