import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Color titleColor;
  SectionTitle({this.title="", this.titleColor =Colors.black });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only( left: 15.0, top: 15.0, bottom: 10.0 ),
      child: Text(title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            letterSpacing: 2.0,
            color: titleColor.withOpacity(0.75)),
      ),
    );
  }
}
