import 'package:flutter/material.dart';
import 'dart:async';
import './glob.dart' as glob;

void main() async {
  glob.ref = await glob.getRef();
  await glob.buildCategories('');
  await glob.buildItems('');
  runApp(TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Help'),
                Tab(text: 'Quiz'),
                Tab(text: 'About'),
              ],
            ),
            title: Text('Melrose Alliance Against Violence'),
          ),
          body: TabBarView(
            children: [
              ResourcePage(title: 'test'),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}

class ResourcePage extends StatefulWidget {
  ResourcePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ResourcePageState createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> coloredBox = [];
    Color bgColor;
    List<Widget> listItems = [
      Padding(
        padding: EdgeInsets.fromLTRB(10, 15, 10, 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 4.0, color: Color(0xFFFF000000)),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Resources',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      )
    ];

    glob.resourceInfo.forEach((k, v) {
      if (glob.resourceInfo[k].length > 0) {
        coloredBox.add(Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
          child: Text(k,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
        ));

        for (var i in glob.resourceInfo[k]) {
          coloredBox.add(ResourceItem(title: i["title"], blurb: i["blurb"]));
        }

        try {
          bgColor = glob.HexColor(
              glob.catInfo[glob.resourceInfo[k][0]["catID"]]["color"]);
        } catch (e) {
          bgColor = Color(0xffffffff);
        }

        listItems.add(
          Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 20),
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Color(0x88888888),
                    offset: new Offset(0.0, 0.0),
                    blurRadius: 3.0,
                  )
                ],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bgColor, bgColor],
                  tileMode:
                      TileMode.clamp, // repeats the gradient over the canvas
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(children: coloredBox),
              ),
            ),
          ),
        );
      }
      coloredBox = [];
    });

    return ListView(
        shrinkWrap: true, padding: EdgeInsets.all(15.0), children: listItems);
  }
}

class ResourceItem extends StatefulWidget {
  ResourceItem({Key key, this.title, this.blurb}) : super(key: key);
  final String title;
  final String blurb;

  @override
  _ResourceItemState createState() => _ResourceItemState();
}

class _ResourceItemState extends State<ResourceItem> {
  double height = 60;
  bool vis = true;
  MainAxisAlignment columnSpacing = MainAxisAlignment.spaceEvenly;
  List<Widget> contents = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if(height == 200) {
              height = 60;
              new Timer.periodic(Duration(milliseconds: 300), (Timer t) => columnSpacing = MainAxisAlignment.spaceEvenly);
             } else {
               columnSpacing = MainAxisAlignment.start;
               height = 200;
              //  new Timer.periodic(Duration(milliseconds: 300), (Timer t) => );
             }
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: double.infinity,
          height: height,
          color: Color(0xffffffff),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: columnSpacing,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.blurb,
                    style: TextStyle(fontSize: 10),
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
