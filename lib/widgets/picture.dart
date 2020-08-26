import 'package:flutter/material.dart';


class Picture extends StatelessWidget {

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(9),
      child: Image.asset(
        'assets/images/tomato.png',
        height: picHeight(context),
        width: picWidth(context),
      )
    );
  }

  double picHeight(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return 100;
    }
    return 200;
  }

  double picWidth(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return 100;
    }
    return 200;
  }

}