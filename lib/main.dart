library maav.main;

import 'package:flutter/material.dart';
import './glob.dart' as glob;

void main() async {
  glob.ref = await glob.getRef();
  await glob.buildCategories('');
  await glob.buildItems('');

  runApp(MaterialApp(
    title: 'MAAV',
    theme: ThemeData(
      primarySwatch: Colors.amber,
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  double height = 60;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          coloredBox.add(Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    height == 200 ? height = 60 : height = 200;
                  });
                },
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: double.infinity,
                    height: height,
                    color: Color(0xff14ff65),
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: makeItem(context, i["title"], i["blurb"],
                            showDialogue(context), height))),
              )));
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

    List<Widget> _widgetOptions = <Widget>[
      ListView(
          shrinkWrap: true, padding: EdgeInsets.all(10.0), children: listItems),
      maavPage(),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text('Melrose Alliance Against Violence'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text('Resources'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              title: Text('About'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber,
          onTap: _onItemTapped,
        ),
        body: _widgetOptions.elementAt(_selectedIndex));
  }
}

ListView maavPage() {
  return ListView(shrinkWrap: true, padding: EdgeInsets.all(15.0), children: [
    ClipRRect(
      borderRadius: new BorderRadius.circular(8.0),
      child: Image.asset('assets/logo_maav.gif'),
    ),
    SizedBox(height: 20),
    Text('About Us', style: glob.headerStyle),
    SizedBox(height: 20),
    Text(
        'Formed in 1995, the Melrose Alliance Against Violence (MAAV) is a nonprofit community-based organization that focuses on outreach, education and community collaboration in order to raise awareness of the problems of bullying, teen dating and domestic violence. Working closely with the Melrose Police Department and Melrose Public Schools, our Board of Directors includes representatives from the city, police, schools, clergy, hospital, business community, Health Department, students, parents and community members at large.',
        style: glob.paragraphStyle),
    SizedBox(height: 20),
    Text(
        'Our programs include community awareness activities, outreach and support for victims, training for parents and professionals, and education and prevention programs for youth.',
        style: glob.paragraphStyle),
    SizedBox(height: 20),
    Text(
        'We hope this web site provides useful information on bullying, teen dating and domestic violence, our programs and services, and critical resources for help. If you are unable to find the information you need, or would like to ask a confidential question, please click on Contact Us. We’ll respond via email as soon as we can.',
        style: glob.paragraphStyle),
    SizedBox(height: 20),
    ClipRRect(
      borderRadius: new BorderRadius.circular(8.0),
      child: Image.asset('assets/buttons.jpg'),
    ),
    SizedBox(height: 20),
    Text('Mission', style: glob.headerStyle),
    SizedBox(height: 20),
    Text(
        'The mission of the Melrose Alliance Against Violence is to raise community awareness of domestic and teen dating violence, and to promote programs that work to reduce violence and encourage healthy relationships.',
        style: glob.paragraphStyle),
    SizedBox(height: 20),
    Text(
        'Our programs include community awareness activities, education and prevention programs in the schools, including bullying prevention, mentoring and peer leadership programs; and information, support, resource and referral services for victims, family members and the community at large.',
        style: glob.paragraphStyle),
    SizedBox(height: 20),
    ClipRRect(
      borderRadius: new BorderRadius.circular(8.0),
      child: Image.asset('assets/estate.jpg'),
    ),
    SizedBox(height: 20),
    Text('Contact & Location', style: glob.headerStyle),
    SizedBox(height: 20),
    Text(
        'The MAAV offices are located on the 2nd floor of the historic Beebe Estate at: ',
        style: glob.paragraphStyle),
    // RaisedButton(
    //   onPressed: launchMap,
    //   child: Text('235 West Foster Street in Melrose, Massachusetts',
    //       style: glob.paragraphStyle),
    // ),
    Text(' Parking is available in the rear lot.', style: glob.paragraphStyle),
  ]);
}

Text makeItem(
    context, String titleText, String subtitleText, dialogue, double height) {
  // var listTile;
  // if (subtitleText != '') {
  //   listTile = ListTile(
  //     // leading: Icon(cardIcon),
  //     title: Text(titleText),
  //     subtitle: Text(subtitleText),
  //     trailing: Icon(Icons.arrow_forward_ios),
  //   );
  // } else {
  //   listTile = ListTile(
  //     title: Text(titleText),
  //     trailing: Icon(Icons.arrow_forward_ios),
  //   );
  // }

  return Text(titleText);

  // return Card(
  //   child: GestureDetector(
  //     onTap: () {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return showDialogue(context);
  //         },
  //       );
  //     },
  //     child: ListTileTheme(
  //       contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
  //       dense: false,
  //       child: listTile,
  //     ),
  //   ),
  // );
}

class ResourcePage extends StatelessWidget {
  final String title;
  final String btnTitle;
  const ResourcePage(this.title, this.btnTitle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(btnTitle),
        ),
      ),
    );
  }
}

AlertDialog showDialogue(BuildContext context) {
  return AlertDialog(
    title: new Text("Alert Dialog title"),
    content: new Text("Alert Dialog body"),
    actions: <Widget>[
      // usually buttons at the bottom of the dialog
      new FlatButton(
        child: new Text("Close"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
