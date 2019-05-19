import 'package:flutter/material.dart';

width(context, double per) {
  return (MediaQuery.of(context).size.width * per);
}

height(context, double per) {
  return (MediaQuery.of(context).size.height * per);
}

pushMember(context, page) {
  Navigator.of(context).push(new MaterialPageRoute(builder: (context) => page));
}

TextStyle headStyle(int color) {
  return TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      color: Color(color),
      fontSize: 30.0);
}

TextStyle subHeadStyle(int color) {
  return TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      color: Color(color),
      fontSize: 23.0);
}

TextStyle bodyStyle(int color) {
  return TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      color: Color(color),
      fontSize: 16.0);
}

TextStyle textStyle = TextStyle(
    fontFamily: 'Montserrat', color: Color(0xdd333333), fontSize: 16.0);

BoxDecoration boxDec(color) {
  return BoxDecoration(
    boxShadow: [
      new BoxShadow(
        color: Color(0x88000000),
        offset: new Offset(1, 1),
        blurRadius: 3,
      )
    ],
    borderRadius: BorderRadius.circular(6),
    color: Color(color),
  );
}

String data = '[{"title":"Emergency","data":[{"title":"Call 911","phone":"911","tty":"","web":"","blurb":"","id":0},{"title":"Domestic Violence Officer","phone":"(781) 979-4432","tty":"","web":"","blurb":"","id":1}],"id":0},{"title":"Support Services","data":[{"title":"Alliance Against Violence","phone":"(781) 662-2010","tty":"","web":"","blurb":"","id":0},{"title":"Riverside Counseling Center","phone":"(781) 246-2010","tty":"","web":"","blurb":"","id":1},{"title":"Respond","phone":"(617) 623-5900","tty":"","web":"https://www.respondinc.org/","blurb":"","id":2}],"id":1},{"title":"Hotlines/Helplines","data":[{"title":"Teen Dating Abuse Helpline","phone":"1-866-331-9474","tty":"1-866-331-8453","web":"","blurb":"","id":0},{"title":"National Domestic Violence Hotline","phone":"1-800-799-7233","tty":"1-800-787-3224","web":"","blurb":"","id":1},{"title":"AIDS Center for Disease Control","phone":"1-800-CDC-INFO","tty":"","web":"","blurb":"","id":2},{"title":"Alateen","phone":"1-508-366-0556","tty":"","web":"","blurb":"","id":3},{"title":"Boston Area Rape Crisis","phone":"1-800-841-8371","tty":"","web":"","blurb":"","id":4},{"title":"National Child Abuse Hotline","phone":"1-800-422-4453","tty":"","web":"","blurb":"","id":5},{"title":"Drug Abuse","phone":"1-877-553-TEEN","tty":"","web":"","blurb":"","id":6},{"title":"Gay & Lesbian Youth Peer Listening","phone":"1-800-399-PEER","tty":"","web":"","blurb":"","id":7},{"title":"Suicide-SamariTeens","phone":"1-800-252-TEEN","tty":"","web":"","blurb":"","id":8},{"title":"National Runaway Safeline","phone":"1-800-786-2929","tty":"","web":"","blurb":"","id":9},{"title":"National Suicide Prevention Lifeline","phone":"1-800-273-8255","tty":"","web":"","blurb":"","id":10},{"title":"Samaritans statewide Helpline","phone":"1-877-870-4673","tty":"","web":"","blurb":"","id":11},{"title":"The Trevor Project (hotline for LGBTQ Youth","phone":"1-899-488-7386","tty":"","web":"","blurb":"","id":12},{"title":"The Network/La Red (LGBTQ community)","phone":"1-800-832-1901","tty":"","web":"","blurb":"","id":13},{"title":"SafeLink","phone":"1-877-785-2020","tty":"","web":"","blurb":"","id":14}],"id":2},{"title":"Help for Abusers","data":[{"title":"Emerge","phone":"(617) 547-9879","tty":"","web":"","blurb":"","id":0}],"id":3},{"title":"Websites","data":[{"title":"Love is Respect","phone":"","tty":"","web":"loveisrespect.org","blurb":"","id":0},{"title":"Choose Respect","phone":"","tty":"","web":"chooserespect.org","blurb":"","id":1},{"title":"The Safe Space","phone":"","tty":"","web":"thesafespace.org","blurb":"","id":2}],"id":4}]';
