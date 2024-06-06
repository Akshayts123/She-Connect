import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:she_connect/Const/network.dart';

Future allFilterAPI(rating, category, max, min) async {
  print(baseUrl +
      filterPort +
      ratingFilter +
      rating +
      "&" +
      categoryFilter +
      category +
      "&" +
      maxAmtFilter +
      max +
      "&" +
      minAmtFilter +
      min);
  final response = await http.get(
    Uri.parse(baseUrl +
        filterPort +
        ratingFilter +
        rating +
        "&" +
        categoryFilter +
        category +
        "&" +
        maxAmtFilter +
        max +
        "&" +
        minAmtFilter +
        min),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print(
        "`````````````````````" + response.body + "``````````````````````````");
  }
  return convertDataToJson;
}

Future onlyCatAPI(category) async {
  print("cattt: " + category.toString());
  // print(baseUrl + filterPort + categoryFilter + category);
  final response = await http.get(
    Uri.parse(baseUrl + filterPort + categoryFilter + category),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print(
        "`````````````````````" + response.body + "``````````````````````````");
  }
  return convertDataToJson;
}

Future onlyPrice(low, high) async {
  print(baseUrl + filterPort + maxAmtFilter + high + "&" + minAmtFilter + low);
  final response = await http.get(
    Uri.parse(
        baseUrl + filterPort + maxAmtFilter + high + "&" + minAmtFilter + low),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print(
        "`````````````````````" + response.body + "``````````````````````````");
  }
  return convertDataToJson;
}

Future onlyHighPrice(high) async {
  print(baseUrl + filterPort + maxAmtFilter + high);
  final response = await http.get(
    Uri.parse(baseUrl + filterPort + maxAmtFilter + high),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print(
        "`````````````````````" + response.body + "``````````````````````````");
  }
  return convertDataToJson;
}

Future onlyRating(rating) async {
  print(baseUrl + filterPort + ratingFilter + rating);
  final response = await http.get(
    Uri.parse(baseUrl + filterPort + ratingFilter + rating),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print(
        "`````````````````````" + response.body + "``````````````````````````");
  }
  return convertDataToJson;
}

Future withoutRating(low, high, catID) async {
  print(baseUrl +
      filterPort +
      categoryFilter +
      catID +
      "&" +
      maxAmtFilter +
      high +
      "&" +
      minAmtFilter +
      low);
  final response = await http.get(
    Uri.parse(baseUrl +
        filterPort +
        categoryFilter +
        catID +
        "&" +
        maxAmtFilter +
        high +
        "&" +
        minAmtFilter +
        low),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print(
        "`````````````````````" + response.body + "``````````````````````````");
  }
  return convertDataToJson;
}

Future withoutPrice(rating, catID) async {
  print(baseUrl +
      filterPort +
      ratingFilter +
      rating +
      "&" +
      categoryFilter +
      catID);
  final response = await http.get(
    Uri.parse(baseUrl +
        filterPort +
        ratingFilter +
        rating +
        "&" +
        categoryFilter +
        catID),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print(
        "`````````````````````" + response.body + "``````````````````````````");
  }
  return convertDataToJson;
}

Future withoutCategory(rating, low, high) async {
  print(baseUrl +
      filterPort +
      ratingFilter +
      rating +
      "&" +
      maxAmtFilter +
      high +
      "&" +
      minAmtFilter +
      low);
  final response = await http.get(
    Uri.parse(baseUrl +
        filterPort +
        ratingFilter +
        rating +
        "&" +
        maxAmtFilter +
        high +
        "&" +
        minAmtFilter +
        low),
    headers: {"accept": "*/*"},
  );
  var convertDataToJson;

  if (response.statusCode == 200) {
    convertDataToJson = jsonDecode(response.body.toString());
  } else {
    convertDataToJson = 0;
    print(
        "`````````````````````" + response.body + "``````````````````````````");
  }
  return convertDataToJson;
}
