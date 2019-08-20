library maav.main;

import 'package:flutter/material.dart';
import './glob.dart' as glob;

void main() async {
  await glob.buildCatData();
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

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = [Text('Hotlines/Helplines')];
    for (var i in glob.resourceInfo) {
      listItems.add(makeCard(context, i["title"], i["blurb"], Icons.help,
          ResourcePage(i["title"], i["title"])));
    }

    List<Widget> _widgetOptions = <Widget>[
      ListView(
          shrinkWrap: true, padding: EdgeInsets.all(15.0), children: listItems),
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
      body: _widgetOptions.elementAt(_selectedIndex),
    );
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

Card makeCard(context, String titleText, String subtitleText, IconData cardIcon,
    nextPage) {
  return Card(
    child: GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => nextPage));
      },
      child: ListTileTheme(
        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        dense: false,
        child: ListTile(
          // leading: Icon(cardIcon),
          title: Text(titleText),
          subtitle: Text(subtitleText),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    ),
  );
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
