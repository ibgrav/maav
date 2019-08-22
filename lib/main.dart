import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
        padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Text(
                  'Resources',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: glob.darkFont),
                ),
                SizedBox(height: 10),
                Container(
                  height: 5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: glob.darkFont),
                )
              ],
            ),
          ),
        ),
      ),
    ];

    glob.resourceInfo.forEach((k, v) {
      if (glob.resourceInfo[k].length > 0) {
        coloredBox.add(Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
          child: Text(k,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: glob.darkFont)),
        ));

        for (var i in glob.resourceInfo[k]) {
          coloredBox.add(ResourceItem(
              title: i["title"],
              blurb: i["blurb"],
              phone: i["phone"],
              tty: i["tty"],
              website: i["website"]));
        }

        try {
          bgColor = glob.HexColor(
              glob.catInfo[glob.resourceInfo[k][0]["catID"]]["color"]);
        } catch (e) {
          bgColor = Color(0xffffffff);
        }

        listItems.add(
          Padding(
            padding: EdgeInsets.fromLTRB(3, 5, 3, 15),
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Color(0x88888888),
                    offset: new Offset(0.0, 0.0),
                    blurRadius: 2.0,
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

    //for bottom screen padding
    listItems.add(SizedBox(height: 60));

    return ListView(
        shrinkWrap: true, padding: EdgeInsets.all(10.0), children: listItems);
  }
}

class ResourceItem extends StatefulWidget {
  ResourceItem(
      {Key key, this.title, this.blurb, this.phone, this.tty, this.website})
      : super(key: key);
  final String title;
  final String blurb;
  final String phone;
  final String tty;
  final String website;

  @override
  _ResourceItemState createState() => _ResourceItemState();
}

class _ResourceItemState extends State<ResourceItem> {
  double maxHeight = 60;
  bool open = false;
  BoxConstraints constraints = BoxConstraints();
  bool vis = true;
  MainAxisAlignment columnSpacing = MainAxisAlignment.spaceEvenly;

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.title,
          style: TextStyle(fontSize: 18, color: glob.darkFont),
        ),
      ),
    ];

    if (widget.blurb != '') {
      contents.add(SizedBox(height: 5));
      contents.add(Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.blurb,
          style: TextStyle(fontSize: 13, color: glob.darkFont),
        ),
      ));
    }

    if (widget.phone != '') {
      contents.add(SizedBox(height: 5));
      contents.add(Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Phone: ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: glob.darkFont),
            ),
            GestureDetector(
              onTap: () async {
                await glob.launchURL('tel://' +
                    widget.phone.replaceAll(RegExp('[^a-zA-Z0-9]'), ''));
              },
              child: Text(
                widget.phone,
                style: TextStyle(fontSize: 15, color: glob.linkFont),
              ),
            ),
          ],
        ),
      ));
    }

    if (widget.tty != '') {
      contents.add(SizedBox(height: 5));
      contents.add(Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TTY: ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: glob.darkFont),
            ),
            GestureDetector(
              onTap: () async {
                await glob.launchURL('sms://' +
                    widget.tty.replaceAll(RegExp('[^a-zA-Z0-9]'), ''));
              },
              child: Text(
                widget.tty,
                style: TextStyle(fontSize: 15, color: glob.linkFont),
              ),
            ),
          ],
        ),
      ));
    }

    if (widget.website != '') {
      contents.add(SizedBox(height: 5));
      contents.add(Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Website: ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: glob.darkFont),
            ),
            GestureDetector(
              onTap: () async {
                await glob.launchURL(widget.website);
              },
              child: Text(
                widget.website.replaceAll('https://', '').replaceAll('http://', '').replaceAll('www.', ''),
                style: TextStyle(fontSize: 15, color: glob.linkFont),
              ),
            ),
          ],
        ),
      ));
    }

    return Padding(
      padding: EdgeInsets.all(3),
      child: GestureDetector(
        onTap: () {
          setState(() {
            open = !open;

            // if (open) {
            //   constraints = BoxConstraints(minHeight: 400);
            // } else {
            //   constraints = BoxConstraints();
            // }
          });
        },
        child: AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Color(0xffffffff),
            boxShadow: [
              new BoxShadow(
                color: Color(0x88888888),
                offset: new Offset(0.0, 0.0),
                blurRadius: 2.0,
              )
            ],
          ),
          duration: Duration(milliseconds: 100),
          width: double.infinity,
          constraints: constraints,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: columnSpacing,
              children: contents,
            ),
          ),
        ),
      ),
    );
  }
}
