library maav.glob;

import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import './main.dart' as main;

String ref = "";
String masterURL = 'https://maav.cdn.prismic.io/api/v1/documents/search';
String itemsParams =
    '&q=[[at(document.type,"item")]]&orderings=[my.item.order]';
String categoriesParams =
    '&q=[[at(document.type,"category")]]&orderings=[my.category.order]';
Map resourceInfo = {};
Map catInfo = {};

getHttp(url) async {
  print('GET - ' + url);
  try {
    Response response = await Dio().get(url);

    print('GET success');
    String data = jsonEncode(response.data);
    return data;
  } catch (e) {
    print(e);
    return 'err';
  }
}

getRef() async {
  var data = await getHttp('https://maav.prismic.io/api/v2');
  var returnData = 'err';
  if (data != 'err') {
    var json = jsonDecode(data);
    for (var ref in json["refs"]) {
      if (ref["id"] == "master") returnData = ref["ref"];
    }
  }
  return returnData;
}

buildCategories(String nextPage) async {
  String getUrl = masterURL;

  if (nextPage != '')
    getUrl = nextPage;
  else
    getUrl += '?ref=' + ref + categoriesParams;

  var data = await getHttp(getUrl);
  if (data != 'err') {
    var json = jsonDecode(data);
    for (var cat in json["results"]) {
      try {
        resourceInfo[cat["data"]["category"]["title"]["value"]] = [];
        catInfo[cat["id"]] = {};
        catInfo[cat["id"]]["title"] = cat["data"]["category"]["title"]["value"];
        catInfo[cat["id"]]["color"] = cat["data"]["category"]["color"]["value"];
      } catch (e) {
        print(e);
      }
    }
  }
}

buildItems(String nextPage) async {
  var newData = {};
  String getUrl = masterURL;

  if (nextPage != '')
    getUrl = nextPage;
  else
    getUrl += '?ref=' + ref + itemsParams;

  var data = await getHttp(getUrl);
  if (data != 'err') {
    var json = jsonDecode(data);
    for (var item in json["results"]) {
      try {
        newData["title"] = item["data"]["item"]["title"]["value"];
      } catch (e) {
        newData["title"] = "";
      }
      try {
        newData["category"] = catInfo[item["data"]["item"]["cat"]["value"]["document"]["id"]]["title"];
        newData["catID"] = item["data"]["item"]["cat"]["value"]["document"]["id"];
      } catch (e) {
        newData["category"] = "";
      }
      try {
        newData["phone"] = item["data"]["item"]["phone"]["value"];
      } catch (e) {
        newData["phone"] = "";
      }
      try {
        newData["tty"] = item["data"]["item"]["tty"]["value"];
      } catch (e) {
        newData["tty"] = "";
      }
      try {
        newData["website"] = item["data"]["item"]["website"]["value"]["url"];
      } catch (e) {
        newData["website"] = "";
      }
      try {
        newData["blurb"] = item["data"]["item"]["blurb"]["value"];
      } catch (e) {
        newData["blurb"] = "";
      }

      if (newData["category"] != "") {
        resourceInfo[newData["category"]].add(newData);
      }

      newData = {};
    }

    if (json["next_page"] != null) {
      await buildItems(json["next_page"]);
    }
  }
}

read(filename, old) async {
  print('READ');
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/' + filename + '.txt');

    var lastModified = await file.lastModified();
    var age = DateTime.now().difference(lastModified).inDays;

    if (age > old) return 'old';

    String text = await file.readAsString();
    return text;
  } catch (e) {
    print("Couldn't read file");
    return 'err';
  }
}

save(filename, data) async {
  print('SAVE');
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/' + filename + '.txt');
  final text = data;
  await file.writeAsString(text);
  return true;
}

launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

launchMap() async {
  String url =
      'https://www.google.com/maps/place/Melrose+Alliance+Against+Violc/@42.4562877,-71.0719118,17z/data=!3m1!4b1!4m5!3m4!1s0x89e373bc5aa16579:0x9b701d5f0539131f!8m2!3d42.4562877!4d-71.0697231';
  String googleMaps = 'comgooglemaps://?center=42.4562877,-71.0719118}';
  if (await canLaunch(googleMaps)) {
    await launch(googleMaps);
  } else {
    throw 'Could not launch $googleMaps';
  }
}

TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
TextStyle paragraphStyle =
    TextStyle(fontSize: 15, fontWeight: FontWeight.normal);

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}