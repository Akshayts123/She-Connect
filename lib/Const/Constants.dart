import 'dart:ui';

import 'package:flutter/material.dart';

const grey = Color(0xff909090);
const greyTxtClr = Color(0xff5F5F5F);
const textFieldGrey = Color(0xffF6F6F6);
const BGgrey = Color(0xffEAEAEA);
const green = Color(0xff11D400);
const radioClr = Color(0xff454545);
final prdCategoryCircleClr = Color(0xffFADAD7);
const darkPink = Color(0xff960145);
const liteGrey = Color(0xffF4F4F4);
const carouselNotActive = Color(0xff2E3A59);
const bgLiteHilightColor = Color(0xfffff3f2);
const badgeTxt =
    TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white);
const size18_700 = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    fontFamily: 'Segoe');
const size18_400 = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    fontFamily: 'Segoe');
const size16_700W = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    fontFamily: 'Segoe');

const size18_400Pink = TextStyle(
    color: darkPink,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    fontFamily: 'Segoe');
const size18_700Pink = TextStyle(
    color: darkPink,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    fontFamily: 'Segoe');

const size16_600W = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    fontFamily: 'Segoe');

const appBarTxtStyl =
    TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600);
const appBarTxtStylW =
    TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
const size16_400Green = TextStyle(
    color: Color(0xff03A100), fontSize: 16, fontWeight: FontWeight.w400);

const size14_700 = TextStyle(
    color: darkPink,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    fontFamily: 'Segoe');

const size14_600 = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    fontFamily: 'Segoe');

const size14_600Green = TextStyle(
    color: Color(0xff0C9600),
    fontWeight: FontWeight.w600,
    fontSize: 14,
    fontFamily: 'Segoe');
const size14_600Red = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    fontFamily: 'Segoe');

const size14_400Cross = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    decoration: TextDecoration.lineThrough,
    fontFamily: 'Segoe');

const size16_700 = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    fontFamily: 'Segoe');

const size16_400 = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    fontFamily: 'Segoe');

const size16_400Grey = TextStyle(
    color: Colors.blueGrey,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
    fontSize: 16,
    fontFamily: 'Segoe');
const size16_400PinkCut = TextStyle(
    color: darkPink,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
    fontSize: 16,
    fontFamily: 'Segoe');
const size16_400Pink = TextStyle(
    color: darkPink,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    fontFamily: 'Segoe');

const size16_400grey = TextStyle(
    color: Colors.blueGrey,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    fontFamily: 'Segoe');

const size16_600pink = TextStyle(
    color: darkPink,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    fontFamily: 'Segoe');

const size12_400 =
    TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Segoe');
const size10_600 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    fontFamily: 'Segoe',
    color: Colors.black);
const size10_400 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    fontFamily: 'Segoe',
    color: Colors.black);

const size12_400Cross = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Segoe',
    decoration: TextDecoration.lineThrough);

const size12_400Grey = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Segoe',
    color: Colors.blueGrey);

const size14_600W = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'Segoe');

const size30 =
    TextStyle(fontSize: 30, fontWeight: FontWeight.w500, fontFamily: 'Segoe');

const size22_600 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontFamily: 'Segoe');
const size24_400 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontFamily: 'Segoe');
const size22_400 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontFamily: 'Segoe');

const size22_600W = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'Segoe');

const size12_400W = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: 'Segoe');

const size12_700W = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontFamily: 'Segoe');
const size12_700 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    fontFamily: 'Segoe');
const size12_700Grey = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: greyTxtClr,
    fontFamily: 'Segoe');

const size14_600Grey = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Colors.blueGrey,
    fontFamily: 'Segoe');

const size13_400Green = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.green,
    fontFamily: 'Segoe');

const size14_400Grey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.blueGrey,
    fontFamily: 'Segoe');
const size14_400 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontFamily: 'Segoe');

const size14_600Pink = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: darkPink,
    fontFamily: 'Segoe');

const size13_400 =
    TextStyle(fontSize: 13, fontWeight: FontWeight.w400, fontFamily: 'Segoe');

const bottomNavPrice = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    fontFamily: 'Segoe');

const size20_400 = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    fontFamily: 'Segoe');

const buttonGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xff9B0F4E),
    Color(0xffCF492C),
  ],
);

h(double h) {
  return SizedBox(height: h);
}

w(double w) {
  return SizedBox(width: w);
}
