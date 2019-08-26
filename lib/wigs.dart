import 'package:flutter/material.dart';
import './glob.dart' as glob;

Padding pageTitle(String title) {
  return Padding(
    padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
    child: Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: glob.darkFont),
            ),
            SizedBox(height: 10),
            Container(
              height: 5,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0), color: glob.darkFont),
            )
          ],
        ),
      ),
    ),
  );
}