import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

String ref = "";
String masterURL = 'https://maav.cdn.prismic.io/api/v1/documents/search';
String itemsParams =
    '&q=[[at(document.type,"item")]]&orderings=[my.item.order]';
String categoriesParams =
    '&q=[[at(document.type,"category")]]&orderings=[my.category.order]';
String aboutParams = '&q=[[at(document.type,"about_page")]]';
String updateParams = '&q=[[at(document.type,"update_app")]]';
String quizYesNoParams = '&q=[[at(document.type,"quiz_yesno")]]';
Map resourceInfo = {};
Map catInfo = {};
List<Map> aboutData = [];
String itemsData = "{\"pages\":[";
String categoriesData = "";
String aboutUsData = "";
String quizData = "{\"pages\":[";
List<Map> quizOutput = [];
String updateTime = "";

Color darkFont = Color(0xFFFF666666);
Color linkFont = Color(0xFFFF6666FF);

initializeApp() async {
  String code = 'err';

  ref = await getRef();
  // updateTime = await getUpdateTime();
  if (ref != 'err') {
    await buildAboutUs();
    await buildCategories('');
    await buildItems('');
    await buildQuizes('');
    save('aboutUs', aboutUsData);
    save('categories', categoriesData);
    save('items', itemsData);
    save('quizes', quizData);
    code = 'success';
  } else {
    String aboutUsCheck = await checkStorage('aboutUs');
    String categoriesCheck = await checkStorage('categories');
    String itemsCheck = await checkStorage('items');
    String quizCheck = await checkStorage('quizes');

    code = 'success';

    if (aboutUsCheck != 'err')
      aboutUsCrawl(aboutUsCheck);
    else
      code = 'err';
    if (categoriesCheck != 'err')
      categoriesCrawl(categoriesCheck);
    else
      code = 'err';
    if (itemsCheck != 'err')
      itemsCrawl(itemsCheck);
    else
      code = 'err';
    if (quizCheck != 'err')
      quizCrawl(quizCheck);
    else
      code = 'err';
  }

  return code;
}

checkStorage(String title) async {
  String text = 'err';
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/' + title + '.txt');

    // var lastModified = await file.lastModified();
    // var serverUpdateDate = DateTime.parse(updateTime.replaceAll('T', ' '));
    // var age = DateTime.now().difference(lastModified).inDays;

    // Duration timecheck = new Duration(hours:0, minutes:0, seconds:0);
    // if (lastModified.difference(serverUpdateDate) < timecheck) text = 'err';
    // else {
    print('READ - ' + title);
    text = await file.readAsString();
    // }
  } catch (e) {
    print(e);
  }

  return text;
}

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

getUpdateTime() async {
  String getUrl = masterURL + '?ref=' + ref + updateParams;
  var data = await getHttp(getUrl);
  if (data != 'err') {
    var json = jsonDecode(data);
    return json["results"][0]["data"]["update_app"]["update_date"]["value"];
  }
  return 'err';
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
    categoriesData += data;
    categoriesCrawl(data);
  }
}

categoriesCrawl(String data) {
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

buildQuizes(String nextPage) async {
  String getUrl = masterURL;

  if (nextPage != '')
    getUrl = nextPage;
  else
    getUrl += '?ref=' + ref + quizYesNoParams;

  var data = await getHttp(getUrl);
  var networkData = "";
  if (data != 'err') {
    quizData += data;
    networkData = "{\"pages\":[" + data + "]}";
    var json = jsonDecode(data);
    quizCrawl(networkData);
    if (json["next_page"] != null) {
      quizData += ",";
      await buildQuizes(json["next_page"]);
    } else
      quizData += "]}";
  }
}

quizCrawl(String data) {
  Map newData = {
    "questions": [],
    "answers": [],
    "title": "",
    "description": ""
  };
  var json = jsonDecode(data);

  newData["type"] = json["pages"][0]["results"][0]["type"];
  for (var page in json["pages"]) {
    for (var result in page["results"]) {
      try {
        newData["title"] = result["data"][newData["type"]]["title"]["value"];
        newData["description"] = result["data"][newData["type"]]["description"]["value"];
      } catch (e) {
        print(e);
      }

      try {
        newData["time"] = result["data"][newData["type"]]["finish_time"]["value"];
      } catch (e) {
        print(e);
      }

      if (newData["type"] == "quiz_yesno") {
        for (var q in result["data"][newData["type"]]["question"]["value"]) {
          try {
            newData["questions"].add(q["text"]["value"]);
          } catch (e) {
            print(e);
          }
        }
        for (var a in result["data"][newData["type"]]["answers"]["value"]) {
          double low = 0;
          double high = 0;
          String text = "";

          try {
            low = a["low"]["value"];
          } catch (e) {
            low = 0;
          }

          try {
            high = a["high"]["value"];
          } catch (e) {
            print('high quiz');
            print(e);
            high = 999;
          }

          try {
            text = a["text"]["value"];
          } catch (e) {
            text = "";
          }

          newData["answers"].add({"low": low, "high": high, "text": text});
        }
      }
    }
  }
  quizOutput.add(newData);
}

buildAboutUs() async {
  String getUrl = masterURL + '?ref=' + ref + aboutParams;
  var data = await getHttp(getUrl);
  if (data != 'err') {
    aboutUsData += data;
    aboutUsCrawl(data);
  }
}

aboutUsCrawl(String data) {
  var json = jsonDecode(data);
  try {
    for (var par in json["results"][0]["data"]["about_page"]["paragraph"]
        ["value"]) {
      if (par.containsKey("image")) {
        aboutData.add({
          "type": "image",
          "src": par["image"]["value"]["url"],
        });
      }
      if (par.containsKey("title")) {
        aboutData.add({
          "type": "title",
          "value": par["title"]["value"],
        });
      }
      if (par.containsKey("text")) {
        aboutData.add({
          "type": "text",
          "value": par["text"]["value"][0]["text"],
        });
      }
      if (par.containsKey("link")) {
        var linkTitle = par["link"]["value"]["url"]
            .replaceAll('https://', '')
            .replaceAll('http://', '')
            .replaceAll('www.', '');
        if (par.containsKey("link_title")) {
          linkTitle = par["link_title"]["value"];
        }
        aboutData.add({
          "type": "link",
          "value": par["link"]["value"]["url"],
          "title": linkTitle
        });
      }
    }
  } catch (e) {
    print(e);
  }
}

buildItems(String nextPage) async {
  String getUrl = masterURL;

  if (nextPage != '')
    getUrl = nextPage;
  else
    getUrl += '?ref=' + ref + itemsParams;

  var data = await getHttp(getUrl);
  var networkData = "";
  if (data != 'err') {
    itemsData += data;
    networkData = "{\"pages\":[" + data + "]}";
    var json = jsonDecode(data);
    itemsCrawl(networkData);
    if (json["next_page"] != null) {
      itemsData += ",";
      await buildItems(json["next_page"]);
    } else
      itemsData += "]}";
  }
}

itemsCrawl(String data) {
  var newData = {};
  var json = jsonDecode(data);

  for (var page in json["pages"]) {
    for (var item in page["results"]) {
      try {
        newData["title"] = item["data"]["item"]["title"]["value"];
      } catch (e) {
        newData["title"] = "";
      }
      try {
        newData["category"] =
            catInfo[item["data"]["item"]["cat"]["value"]["document"]["id"]]
                ["title"];
        newData["catID"] =
            item["data"]["item"]["cat"]["value"]["document"]["id"];
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
  }
}

save(filename, data) async {
  print('SAVE');
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/' + filename + '.txt');
  final text = data;
  await file.writeAsString(text);
}

launchURL(url) async {
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
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
