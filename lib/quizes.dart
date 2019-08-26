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

    for(var quiz in glob.quizOutput){
      if(quiz["type"] == "quiz_yesno"){
        // listItems.add('');
      }
    }

    return ListView(
        shrinkWrap: true, padding: EdgeInsets.all(10.0), children: listItems);
  }
}