import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

width(context, double per) {
  return (MediaQuery.of(context).size.width * per);
}

height(context, double per) {
  return (MediaQuery.of(context).size.height * per);
}

pushMember(context, page) {
  Navigator.of(context).push(new MaterialPageRoute(builder: (context) => page));
}

launchURL(url) async {
  url = Uri.encodeFull(url);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
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

String data = '[{"title":"Emergency","data":[{"title":"Call 911","sort":0,"phone":"911","tty":"","website":"","blurb":""},{"title":"Domestic Violence Officer","sort":1,"phone":"(781) 979-4432","tty":"","website":"","blurb":""}],"sort":0},{"title":"Support Services","data":[{"title":"Alliance Against Violence","sort":0,"phone":"(781) 662-2010","tty":"","website":"","blurb":""},{"title":"Riverside Counseling Center","sort":1,"phone":"(781) 246-2010","tty":"","website":"","blurb":""},{"title":"Respond","sort":2,"phone":"(617) 623-5900","tty":"","website":"","blurb":""}],"sort":1},{"title":"Hotlines/Helplines","data":[{"title":"Teen Dating Abuse Helpline","sort":0,"phone":"1-866-331-9474","tty":"1-866-331-8453","website":"","blurb":""},{"title":"National Domestic Violence Hotline","sort":1,"phone":"1-800-799-7233","tty":"1-800-787-3224","website":"","blurb":""},{"title":"AIDS Center for Disease Control","sort":2,"phone":"1-800-CDC-INFO","tty":"","website":"","blurb":""},{"title":"Alateen","sort":3,"phone":"1-508-366-0556","tty":"","website":"","blurb":""},{"title":"Boston Area Rape Crisis","sort":4,"phone":"1-800-841-8371","tty":"","website":"","blurb":""},{"title":"National Child Abuse Hotline","sort":5,"phone":"1-800-422-4453","tty":"","website":"","blurb":""},{"title":"Drug Abuse","sort":6,"phone":"1-877-553-TEEN","tty":"","website":"","blurb":""},{"title":"Gay & Lesbian Youth Peer Listening","sort":7,"phone":"1-800-399-PEER","tty":"","website":"","blurb":""},{"title":"Suicide-SamariTeens","sort":8,"phone":"1-800-252-TEEN","tty":"","website":"","blurb":""},{"title":"National Runaway Safeline","sort":9,"phone":"1-800-786-2929","tty":"","website":"","blurb":""},{"title":"National Suicide Prevention Lifeline","sort":10,"phone":"1-800-273-8255","tty":"","website":"","blurb":""},{"title":"Samaritans statewide Helpline","sort":11,"phone":"1-877-870-4673","tty":"","website":"","blurb":""},{"title":"The Trevor Project (hotline for LGBTQ Youth","sort":12,"phone":"1-899-488-7386","tty":"","website":"","blurb":""},{"title":"The Network/La Red (LGBTQ community)","sort":13,"phone":"1-800-832-1901","tty":"","website":"","blurb":""},{"title":"SafeLink","sort":14,"phone":"1-877-785-2020","tty":"","website":"","blurb":""}],"sort":2},{"title":"Help for Abusers","data":[{"title":"Emerge","sort":0,"phone":"(617) 547-9879","tty":"","website":"","blurb":""}],"sort":3},{"title":"Websites","data":[{"title":"Love is Respect","sort":0,"phone":"","tty":"","website":"","blurb":""}],"sort":4}]';