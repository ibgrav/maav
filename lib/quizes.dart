import 'package:flutter/material.dart';
import './glob.dart' as glob;
import './wigs.dart' as wigs;

class QuizPage extends StatefulWidget {
  QuizPage({Key key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = []; //wigs.pageTitle('Quizes')
    int count = 0;
    for (var quiz in glob.quizOutput) {
      count++;
      if (quiz["type"] == "quiz_yesno" && quiz["questions"].length > 0) {
        List<Widget> contents = [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text(
                quiz["title"],
                style: TextStyle(
                    fontSize: 25,
                    color: glob.darkFont,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(
            height: 3.0,
            color: Colors.grey,
          )
        ];

        if (quiz["description"] != "") {
          contents.add(
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Text(
                quiz["description"],
                style: TextStyle(
                    fontSize: 16,
                    color: glob.darkFont,
                    fontWeight: FontWeight.normal),
              ),
            ),
          );
        }

        if (quiz["time"] != "") {
          contents.add(
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(quiz["questions"].length.toString() + ' Questions',
                      style: TextStyle(
                          color: glob.darkFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Text('25 Minutes',
                      style: TextStyle(
                          color: glob.darkFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ],
              ),
            ),
          );
        }

        listItems.add(
          Padding(
            padding: EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TakeQuizPage(title: quiz["title"], index: count)),
                );
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
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: contents,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    count = 0;

    return ListView(
        shrinkWrap: true, padding: EdgeInsets.all(10.0), children: listItems);
  }
}

class TakeQuizPage extends StatefulWidget {
  TakeQuizPage({Key key, this.title, this.index}) : super(key: key);
  final String title;
  final int index;

  @override
  _TakeQuizPageState createState() => _TakeQuizPageState();
}

class _TakeQuizPageState extends State<TakeQuizPage> {
  int currentQ = 0;
  int score = 0;
  String qText = '';
  Column content;

  @override
  Widget build(BuildContext context) {
    if (currentQ < glob.quizOutput[widget.index]["questions"].length) {
      String qText = glob.quizOutput[widget.index]["questions"][currentQ];

      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 30),
              child: Text(qText,
                  style: TextStyle(color: glob.darkFont, fontSize: 25),
                  textAlign: TextAlign.center)),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      currentQ++;
                      score++;
                    });
                  },
                  child: Text('Yes', style: TextStyle(fontSize: 25)),
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      currentQ++;
                    });
                  },
                  child: Text('No', style: TextStyle(fontSize: 25)),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      var response = '';
      for (var answer in glob.quizOutput[widget.index]["answers"]) {
        if (score >= answer["low"] && score <= answer["high"]) {
          response = answer["text"];
        }
      }

      content = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 40, 30, 40),
            child: Text('Your Score: ' + score.toString(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
            child: Text(response,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 60),
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Text('Back to Quizes', style: TextStyle(fontSize: 25)),
            ),
          ),
        ],
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: content,
      ),
    );
  }
}
