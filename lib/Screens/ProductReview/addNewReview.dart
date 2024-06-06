import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:she_connect/API/addProductReview_API.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Helper/snackbar_toast_helper.dart';

class AddNewReview extends StatefulWidget {
  final id;
  final data;
  final Function refresh;
  const AddNewReview({Key? key, this.id, this.data, required this.refresh})
      : super(key: key);

  @override
  _AddNewReviewState createState() => _AddNewReviewState();
}

class _AddNewReviewState extends State<AddNewReview> {
  TextEditingController reviewController = new TextEditingController();

  var finalRating = 1.0;
  var load = true;
  var tap = false;
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

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
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            )),
        title: const Text(
          "Add Review",
          style: appBarTxtStyl,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    productDetail(),
                  ],
                ),
              ),
            ),
            h(10),
            WrittenReview(),
            h(20),
            button()
          ],
        ),
      ),
    );
  }

  productDetail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
                image: DecorationImage(
                    image: NetworkImage(widget.data["image"].toString()),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data["name"].toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: size16_700,
                  ),
                  h(10),
                  ratingBar()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ratingBar() {
    return RatingBar.builder(
      initialRating: 1,
      itemSize: 25,
      minRating: 1,
      glow: true,
      unratedColor: BGgrey,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) =>
          Icon(CupertinoIcons.star_fill, size: 15, color: Colors.yellow[800]!),
      onRatingUpdate: (rating) {
        setState(() {
          finalRating = rating;
        });
        print("rating: " + finalRating.toString());
      },
    );
  }

  WrittenReview() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add a written review", style: size16_700),
            h(10),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: darkPink),
                  color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: reviewController,
                  cursorColor: Colors.black,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  autofocus: false,
                  maxLength: 200,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: size14_400Grey,
                    hintText:
                        "Product is good or bad? What is so special about this product?",
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  button() {
    return GestureDetector(
      onTap: () async {
        if (reviewController.text.length >= 1) {
          setState(() {
            tap = true;
          });
          var rsp = await AddProductReviewAPI(
              widget.id, reviewController.text, finalRating);

          print("rsp");
          print(rsp);
          print("rsp");
          if (rsp["status"].toString() == "success") {
            showToastSuccess("Review Added!");
            Navigator.pop(context);
            widget.refresh();
            setState(() {
              tap = false;
            });
          }
        } else {
          showToastSuccess("Write something about the product!");
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: buttonGradient, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: tap == true
                ? Center(
                    child: SpinKitThreeBounce(
                    color: Colors.white,
                    size: 20,
                  ))
                : Text(
                    "Submit",
                    style: size16_700W,
                  ),
          ),
        ),
      ),
    );
  }
}
