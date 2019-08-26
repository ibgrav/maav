import 'package:flutter/material.dart';
import './glob.dart' as glob;
import './resources.dart' as resources;
import './about.dart' as about;
import './quizes.dart' as quizes;

void main() async {
  var init = await glob.initializeApp();
  // var init = 'err';
  if (init != 'err') 
    runApp(MyApp());
  else
    runApp(NetworkErr());
}

class MyApp extends StatelessWidget {
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
              resources.ResourcePage(),
              quizes.QuizPage(),
              about.AboutPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkErr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Melrose Alliance Against Violence'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(30),
                child: Text('There was an issue connecting to the internet',
                    style: TextStyle(color: glob.darkFont, fontSize: 25), textAlign: TextAlign.center)),
            RaisedButton(
              onPressed: () async {
                var init = await glob.initializeApp();
                if (init != 'err')
                  runApp(MyApp());
                else
                  runApp(NetworkErr());
              },
              child: const Text('Try Again', style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      ),
    );
  }
}