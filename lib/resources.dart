import 'package:flutter/material.dart';
import './glob.dart' as glob;
import './wigs.dart' as wigs;

class ResourcePage extends StatefulWidget {
  ResourcePage({Key key}) : super(key: key);

  @override
  _ResourcePageState createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  @override
  Widget build(BuildContext context) {
    // List<Widget> coloredBox = [];
    Color bgColor;
    List<Widget> listItems = []; //wigs.pageTitle('Resources')

    glob.resourceInfo.forEach((k, v) {
      if (glob.resourceInfo[k].length > 0) {
        try {
          bgColor = glob.HexColor(
              glob.catInfo[glob.resourceInfo[k][0]["catID"]]["color"]);
        } catch (e) {
          bgColor = Color(0xffffffff);
        }

        listItems.add(Category(title: k, bgColor: bgColor));
      }
      // coloredBox = [];
    });

    //for bottom screen padding
    listItems.add(SizedBox(height: 60));

    return ListView(
        shrinkWrap: true, padding: EdgeInsets.all(10.0), children: listItems);
  }
}

class Category extends StatefulWidget {
  Category({Key key, this.title, this.bgColor}) : super(key: key);
  final String title;
  final Color bgColor;

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool open = false;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = [];

    for (var i in glob.resourceInfo[widget.title]) {
      contents.add(ResourceItem(
          title: i["title"],
          blurb: i["blurb"],
          phone: i["phone"],
          tty: i["tty"],
          website: i["website"],
          bgColor: widget.bgColor));
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return Padding(
        padding: EdgeInsets.fromLTRB(3, 5, 3, 15),
        child: Container(
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
              colors: [widget.bgColor, widget.bgColor],
              tileMode: TileMode.clamp, // repeats the gradient over the canvas
            ),
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      open = !open;

                      if (open) {
                        height = 300;
                      } else {
                        height = 0;
                      }
                      print(height);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: glob.darkFont,
                      ),
                    ),
                  ),
                ),
                ...contents
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ResourceItem extends StatefulWidget {
  ResourceItem(
      {Key key,
      this.title,
      this.blurb,
      this.phone,
      this.tty,
      this.website,
      this.bgColor})
      : super(key: key);
  final String title;
  final String blurb;
  final String phone;
  final String tty;
  final String website;
  final Color bgColor;

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
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            widget.title,
            style: TextStyle(
                fontSize: 18,
                color: glob.darkFont,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];

    if (widget.blurb != '') {
      contents.add(Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Text(
            widget.blurb,
            style: TextStyle(fontSize: 16, color: glob.darkFont),
          ),
        ),
      ));
    } else
      contents.add(SizedBox(height: 5));

    if (widget.phone != '') {
      contents.add(Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Phone: ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: glob.darkFont),
            ),
            GestureDetector(
              onTap: () async {
                await glob.launchURL('tel://' +
                    widget.phone.replaceAll(RegExp('[^a-zA-Z0-9]'), ''));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  widget.phone,
                  style: TextStyle(fontSize: 16, color: glob.linkFont),
                ),
              ),
            ),
          ],
        ),
      ));
    }

    if (widget.tty != '') {
      contents.add(Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TTY: ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: glob.darkFont),
            ),
            GestureDetector(
              onTap: () async {
                await glob.launchURL('sms://' +
                    widget.tty.replaceAll(RegExp('[^a-zA-Z0-9]'), ''));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  widget.tty,
                  style: TextStyle(fontSize: 16, color: glob.linkFont),
                ),
              ),
            ),
          ],
        ),
      ));
    }

    if (widget.website != '') {
      contents.add(Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Website: ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: glob.darkFont),
            ),
            GestureDetector(
              onTap: () async {
                await glob.launchURL(widget.website);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  widget.website
                      .replaceAll('https://', '')
                      .replaceAll('http://', '')
                      .replaceAll('www.', ''),
                  style: TextStyle(fontSize: 15, color: glob.linkFont),
                ),
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
            borderRadius: BorderRadius.circular(3.0),
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
