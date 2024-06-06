// import 'package:flutter/material.dart';
// import 'package:she_connect/Const/Constants.dart';
// import 'package:she_connect/Const/TextConst.dart';
//
// import 'RequestReturnORExchange.dart';
//
// class ExchngORReturn extends StatefulWidget {
//   const ExchngORReturn({Key? key}) : super(key: key);
//
//   @override
//   _ExchngORReturnState createState() => _ExchngORReturnState();
// }
//
// class _ExchngORReturnState extends State<ExchngORReturn> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: BGgrey,
//         appBar: AppBar(
//             centerTitle: true,
//             leading: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(Icons.arrow_back,
//                     color: Colors.black, size: 25)),
//             title: Column(children: const [
//               Text(
//                 "Specify Return/Exchange Details",
//                 style: appBarTxtStyl,
//               ),
//               Text("Step 2 of 3", style: size12_400Grey)
//             ])),
//         body: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(children: [
//               productDetail(),
//               h(20),
//               _buttons(),
//               h(15),
//               const Text("Return or Exchange available till 12-Nov",
//                   style: size12_400Grey)
//             ])));
//   }
//
//   productDetail() {
//     return Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10), color: Colors.white),
//         child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//             child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Container(
//                 height: 100,
//                 width: 100,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.black12),
//                     image: const DecorationImage(
//                         image: NetworkImage(bagImg), fit: BoxFit.cover)),
//               ),
//               const SizedBox(width: 15),
//               Expanded(
//                   child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text("Surene tote Bag", style: size16_700),
//                             h(5),
//                             RichText(
//                                 text: const TextSpan(
//                                     text: 'Color:',
//                                     style: size10_600,
//                                     children: [
//                                   TextSpan(text: '  RED', style: size10_600)
//                                 ])),
//                             h(5),
//                             const Text("Qty: 2", style: size14_700)
//                           ])))
//             ])));
//   }
//
//   _buttons() {
//     return Row(children: [
//       Expanded(
//           child: GestureDetector(
//               onTap: () {
//                 print("aaaaaaaaa");
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => RqstReturnOrExchange(
//                               txt: "Return",
//                             )));
//               },
//               child: Container(
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: darkPink, width: 1)),
//                   child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 10),
//                       child: Text("Return", style: size16_600pink))))),
//       w(10),
//       Expanded(
//           child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             RqstReturnOrExchange(txt: "Exchange", refresh: getDetails)));
//               },
//               child: Container(
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: darkPink, width: 1)),
//                   child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 10),
//                       child: Text("Exchange", style: size16_600pink)))))
//     ]);
//   }
// }
