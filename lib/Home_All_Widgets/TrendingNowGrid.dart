import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';

class TrendingNowGrid extends StatefulWidget {
  const TrendingNowGrid({Key? key}) : super(key: key);

  @override
  _TrendingNowGridState createState() => _TrendingNowGridState();
}

class _TrendingNowGridState extends State<TrendingNowGrid> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
              childAspectRatio: 0.59,
              mainAxisExtent: 280,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Grid(index);
            },
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 5,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
              childAspectRatio: 0.59,
              mainAxisExtent: 270,
            ),
            itemBuilder: (BuildContext context, int index) {
              return TabletGrid(index);
            },
          ),
        );
      }
    });
  }

  Grid(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 213,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                  image: const DecorationImage(
                      image: NetworkImage(tstImg), fit: BoxFit.cover)),
            ),
            // const Positioned(
            //   bottom: 15,
            //   right: 10,
            //   child: Icon(
            //     Icons.favorite,
            //     color: Colors.white,
            //   ),
            // ),
            Positioned(
              bottom: 15,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: liteGrey),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Row(
                    children: const [
                      Text(
                        "4.2",
                        style: size12_400,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.black,
                        size: 13,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        h(8),
        const Text(
          "Bestima Cotton Bedsheets",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: size14_400,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              rs + "399",
              style: size16_400,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              rs + "699",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.lineThrough),
            ),
          ],
        ),
      ],
    );
  }

  TabletGrid(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                  image: const DecorationImage(
                      image: NetworkImage(tstImg), fit: BoxFit.cover)),
            ),
            // const Positioned(
            //   bottom: 15,
            //   right: 10,
            //   child: Icon(
            //     Icons.favorite,
            //     color: Colors.white,
            //   ),
            // ),
            Positioned(
              bottom: 15,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: liteGrey),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Row(
                    children: const [
                      Text(
                        "4.2",
                        style: size12_400,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.black,
                        size: 13,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const Text(
          "Bestima Cotton Bedsheeaa ansj abnxsjx xasxbn...",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: size14_700,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              rs + "399",
              style: size16_400,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              rs + "699",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.lineThrough),
            ),
          ],
        ),
      ],
    );
  }
}
