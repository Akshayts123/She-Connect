import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/TextConst.dart';

class RecomendedListHome extends StatefulWidget {
  const RecomendedListHome({Key? key}) : super(key: key);

  @override
  _RecomendedListHomeState createState() => _RecomendedListHomeState();
}

class _RecomendedListHomeState extends State<RecomendedListHome> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (snapshot.maxWidth < 600) {
        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            height: 270,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => w(20),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return TdyDealGrid(index);
              },
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => w(20),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return TdyDealGridTablet(index);
              },
            ),
          ),
        );
      }
    });
  }

  TdyDealGrid(int index) {
    return Container(
      width: 178,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                height: 213,
                width: 178,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        image: NetworkImage(
                            "https://f1af951e8abcbc4c70b9-9997fa854afcb64e87870c0f4e867f1d.lmsin.net/1000008427268-1000008427267_01-710.jpg"),
                        fit: BoxFit.cover)),
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
          Text(
            "Bestima Cotton Bedsheets ",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: size14_400,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                rs + "399",
                style: size16_400,
              ),
              w(10),
              const Text(
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
      ),
    );
  }

  TdyDealGridTablet(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        image: NetworkImage(
                            "https://f1af951e8abcbc4c70b9-9997fa854afcb64e87870c0f4e867f1d.lmsin.net/1000008427268-1000008427267_01-710.jpg"),
                        fit: BoxFit.cover)),
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
            style: size14_400,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                rs + "399",
                style: size16_400,
              ),
              w(10),
              const Text(
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
      ),
    );
  }
}
