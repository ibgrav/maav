library maav.glob;

import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import './main.dart' as main;

String masterURL = 'https://maav.cdn.prismic.io/api/v1/documents/search';
List resourceInfo = [];

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
  if(data != 'err'){
    var json = jsonDecode(data);
    for(var ref in json["refs"]){
      if(ref["id"] == "master") returnData = ref["ref"];
    }
  }
  return returnData;
}

buildCatData() async {
  var ref = await getRef();
  var newData = {};
  if(ref != 'err'){
    var data = await getHttp(masterURL + '?ref=' + ref);
    if(data != 'err'){
      var json = jsonDecode(data);
      for(var item in json["results"]){
        print(item["data"]["item"]);
        try {
          newData["title"] = item["data"]["item"]["title"]["value"][0]["text"];
        } catch(e) {
          print(e);
          newData["title"] = "";
        }
        try {
          newData["category"] = item["data"]["item"]["category"]["value"];
        } catch(e) {
          print(e);
          newData["category"] = "";
        }
        try {
          newData["phone"] = item["data"]["item"]["phone"]["value"];
        } catch(e) {
          print(e);
          newData["phone"] = "";
        }
        try {
          newData["tty"] = item["data"]["item"]["tty"]["value"];
        } catch(e) {
          print(e);
          newData["tty"] = "";
        }
        try {
          newData["website"] = item["data"]["item"]["website"]["value"]["url"];
        } catch(e) {
          print(e);
          newData["website"] = "";
        }
        try {
          newData["blurb"] = item["data"]["item"]["blurb"]["value"][0]["text"];
        } catch(e) {
          print(e);
          newData["blurb"] = "";
        }

        resourceInfo.add(newData);
        newData = {};
      }
    }
  }
  print(resourceInfo);
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
TextStyle paragraphStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.normal);