import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './glob.dart' as glob;

void main() async {
  await buildWidgets();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'MAAV',
      home: Scaffold(
          backgroundColor: Color(0xFF5C748A),
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              'M A A V',
              style: glob.headStyle(0xFFEFEFEF),
            ),
            backgroundColor: Color(0xFF5C748A),
            bottom: PreferredSize(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Container(
                    decoration: glob.boxDec(0xFFEFEFEF),
                    height: 3.0,
                  ),
                ),
                preferredSize: Size.fromHeight(3.0)),
          ),
          body: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: buildWidgets(),
      ),
    );
  }
}

List<Widget> buildWidgets() {
  List<Widget> children = [];

  var json = jsonDecode(glob.data);
  for(var item in json){
    for(var resource in item['data']){
      children.add(
        Text(resource['title'])
      );
    }
  }

  return children;
}
