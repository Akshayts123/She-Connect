import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:she_connect/Const/Constants.dart';

class ProductPolicyPage extends StatefulWidget {
  final data;
  const ProductPolicyPage({Key? key, this.data}) : super(key: key);

  @override
  _ProductPolicyPageState createState() => _ProductPolicyPageState();
}

class _ProductPolicyPageState extends State<ProductPolicyPage> {
  @override
  void initState() {
    print(widget.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Policy", style: appBarTxtStyl),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            )),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Html(
                data: widget.data.toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
