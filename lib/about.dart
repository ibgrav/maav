import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './glob.dart' as glob;

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [];

    for (var i in glob.aboutData) {
      if (i["type"] == "image") {
        if(i != glob.aboutData[0]) content.add(SizedBox(height: 30));
        content.add(
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image(image: CachedNetworkImageProvider(i["src"])),
          ),
        );
      }

      if (i["type"] == "title") {
        content.add(SizedBox(height: 10));
        content.add(Text(i["value"],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: glob.darkFont,
                fontSize: 25)));
      }

      if (i["type"] == "text") {
        content.add(SizedBox(height: 10));
        content.add(Text(i["value"],
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: glob.darkFont,
                fontSize: 18)));
      }

      if (i["type"] == "link") {
        content.add(SizedBox(height: 5));
        content.add(
          GestureDetector(
            onTap: () async {
              await glob.launchURL(i["value"]);
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text(
                i["title"],
                style: TextStyle(fontSize: 18, color: glob.linkFont),
              ),
            ),
          ),
        );
      }
    }

    content.add(SizedBox(height: 60));

    return ListView(
        shrinkWrap: true, padding: EdgeInsets.all(10.0), children: content);
  }
}