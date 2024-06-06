import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:shimmer/shimmer.dart';

class shimmerAddressList extends StatelessWidget {
  shimmerAddressList({Key? key}) : super(key: key);
  List arrAllStoresNearMe = ["a", "a", "a"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemBuilder: (context, index) {
          final item =
              arrAllStoresNearMe != null ? arrAllStoresNearMe[index] : null;
          return storesCard(item, index);
        },
        itemCount: arrAllStoresNearMe.length,
        shrinkWrap: true,
      ),
    );
  }

  storesCard(final item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.white,
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//************************************************************************

class shimmerVendorsGrid extends StatelessWidget {
  shimmerVendorsGrid({Key? key}) : super(key: key);
  List arrAllStoresNearMe = [
    "a",
    "a",
    "a",
    "a",
    "a",
    "a",
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: arrAllStoresNearMe.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75),
        itemBuilder: (BuildContext context, int index) {
          final item =
              arrAllStoresNearMe != null ? arrAllStoresNearMe[index] : null;

          return storesCard(item, index, context);
        });
  }

  storesCard(final item, int index, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.white,
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (Colors.grey[400]!),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    )
                  ],
                  color: liteGrey,
                  border: Border.all(color: Colors.black12),
                ),
              ),
              h(5),
              Container(height: 15, width: 60, color: liteGrey),
              h(5),
              Container(height: 15, width: 50, color: liteGrey),
            ],
          ),
        ),
      ),
    );
  }
}

//************************************************************************

class shimmerProductsGrid extends StatelessWidget {
  shimmerProductsGrid({Key? key}) : super(key: key);
  List arrAllStoresNearMe = [
    "a",
    "a",
    "a",
    "a",
    "a",
    "a",
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: arrAllStoresNearMe.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 0,
            childAspectRatio: 0.6,
            mainAxisExtent: 280),
        itemBuilder: (BuildContext context, int index) {
          final item =
              arrAllStoresNearMe != null ? arrAllStoresNearMe[index] : null;

          return storesCard(item, index, context);
        });
  }

  storesCard(final item, int index, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.white,
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 213,
                decoration: BoxDecoration(
                  color: liteGrey,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              h(8),
              Container(height: 15, width: 80, color: liteGrey),
              h(5),
              Container(height: 15, width: 60, color: liteGrey),
            ],
          ),
        ),
      ),
    );
  }
}

//*******************************************************************

class shimmerProfilePage extends StatelessWidget {
  shimmerProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      enabled: true,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: liteGrey),
        height: 100,
        width: 100,
      ),
    );
  }
}

//**********************************************************************

class shimmerOrdersList extends StatelessWidget {
  shimmerOrdersList({Key? key}) : super(key: key);
  List arrAllStoresNearMe = ["a", "a", "a", "a", "a", "a"];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => Divider(
              color: Colors.grey[300],
              endIndent: 20,
              indent: 20,
              thickness: 1,
            ),
        shrinkWrap: true,
        itemCount: arrAllStoresNearMe.length,
        itemBuilder: (BuildContext context, int index) {
          final item =
              arrAllStoresNearMe != null ? arrAllStoresNearMe[index] : null;

          return storesCard(item, index, context);
        });
  }

  storesCard(final item, int index, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.white,
        enabled: true,
        child: Row(
          children: [
            Container(
              height: 96,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            w(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 15,
                  width: 200,
                  color: Colors.grey[300],
                ),
                h(5),
                Container(
                  height: 15,
                  width: 200,
                  color: Colors.grey[300],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//*********************************************************

class shimmerProductCategoryGrid extends StatelessWidget {
  shimmerProductCategoryGrid({Key? key}) : super(key: key);
  List arrAllStoresNearMe = ["a", "a", "a", "a", "a", "a"];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 5,
            childAspectRatio: 0.52),
        itemCount: arrAllStoresNearMe.length,
        itemBuilder: (BuildContext context, int index) {
          final item =
              arrAllStoresNearMe != null ? arrAllStoresNearMe[index] : null;

          return storesCard(item, index, context);
        });
  }

  storesCard(final item, int index, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.white,
        enabled: true,
        child: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
            ),
            h(5),
            Container(
              height: 15,
              width: 60,
              color: Colors.grey[300],
            )
          ],
        ),
      ),
    );
  }
}

//************************************************************
