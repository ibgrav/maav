import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
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
    List<Widget> _widgetOptions = <Widget>[
      resourcePage(context),
      maavPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Melrose Alliance Against Violence'),
      ),
      drawer: Drawer(child: mainDrawer()),
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

Drawer mainDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Drawer Header'),
          decoration: BoxDecoration(
            color: Colors.amber,
          ),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
      ],
    ),
  );
}

ListView maavPage() {
  return ListView(shrinkWrap: true, padding: EdgeInsets.all(15.0), children: [
    ClipRRect(
      borderRadius: new BorderRadius.circular(8.0),
      child: Image.asset('assets/logo_maav.gif'),
    ),
    SizedBox(height: 20),
    Text('About Us', style: headerStyle),
    SizedBox(height: 20),
    Text(
        'Formed in 1995, the Melrose Alliance Against Violence (MAAV) is a nonprofit community-based organization that focuses on outreach, education and community collaboration in order to raise awareness of the problems of bullying, teen dating and domestic violence. Working closely with the Melrose Police Department and Melrose Public Schools, our Board of Directors includes representatives from the city, police, schools, clergy, hospital, business community, Health Department, students, parents and community members at large.',
        style: paragraphStyle),
    SizedBox(height: 20),
    Text(
        'Our programs include community awareness activities, outreach and support for victims, training for parents and professionals, and education and prevention programs for youth.',
        style: paragraphStyle),
    SizedBox(height: 20),
    Text(
        'We hope this web site provides useful information on bullying, teen dating and domestic violence, our programs and services, and critical resources for help. If you are unable to find the information you need, or would like to ask a confidential question, please click on Contact Us. We’ll respond via email as soon as we can.',
        style: paragraphStyle),
    SizedBox(height: 20),
    ClipRRect(
      borderRadius: new BorderRadius.circular(8.0),
      child: Image.asset('assets/buttons.jpg'),
    ),
    SizedBox(height: 20),
    Text('Mission', style: headerStyle),
    SizedBox(height: 20),
    Text(
        'The mission of the Melrose Alliance Against Violence is to raise community awareness of domestic and teen dating violence, and to promote programs that work to reduce violence and encourage healthy relationships.',
        style: paragraphStyle),
    SizedBox(height: 20),
    Text(
        'Our programs include community awareness activities, education and prevention programs in the schools, including bullying prevention, mentoring and peer leadership programs; and information, support, resource and referral services for victims, family members and the community at large.',
        style: paragraphStyle),
    SizedBox(height: 20),
    ClipRRect(
      borderRadius: new BorderRadius.circular(8.0),
      child: Image.asset('assets/estate.jpg'),
    ),
    SizedBox(height: 20),
    Text('Contact & Location', style: headerStyle),
    SizedBox(height: 20),
    Text(
        'The MAAV offices are located on the 2nd floor of the historic Beebe Estate at: ',
        style: paragraphStyle),
    // RaisedButton(
    //   onPressed: launchMap,
    //   child: Text('235 West Foster Street in Melrose, Massachusetts',
    //       style: paragraphStyle),
    // ),
    Text(' Parking is available in the rear lot.', style: paragraphStyle),
  ]);
}

Card makeCard(context, String titleText, String subtitleText, IconData cardIcon,
    nextPage) {
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(cardIcon),
          title: Text(titleText),
          subtitle: Text(subtitleText),
        ),
        ButtonTheme.bar(
          child: ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => nextPage),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

ListView resourcePage(
  context,
) {
  return ListView(shrinkWrap: true, padding: EdgeInsets.all(15.0), children: [
    makeCard(
        context,
        'Emergency',
        'Melrose Alliance Against Violence Melrose Alliance Against Violence',
        Icons.warning,
        EmergencyPage()),
    makeCard(context, 'Support Services', 'Subtitle', Icons.help, ServicesPage()),
    makeCard(context, 'Hotlines/Helplines', 'Subtitle', Icons.phone_forwarded,
        HelplinesPage()),
    makeCard(
        context, 'Help for Abusers', 'Subtitle', Icons.person, AbusersPage()),
    makeCard(
        context, 'Websites', 'Subtitle', Icons.open_in_browser, WebsitesPage())
  ]);
}

TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
TextStyle paragraphStyle =
    TextStyle(fontSize: 15, fontWeight: FontWeight.normal);

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

class EmergencyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class ServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support Services'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class HelplinesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotlines/Helplines'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class AbusersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help for Abusers'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class WebsitesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Websites'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
