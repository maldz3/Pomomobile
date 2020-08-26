import 'package:flutter/material.dart';
import '../app.dart';

//Used to help change color mode
class CustomDrawer extends StatefulWidget {

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>{
  bool _darkOn;

  @override
  initState() {
    AppState _curState = context.findAncestorStateOfType();
    super.initState();
    _darkOn = _curState.prefs.getBool('_darkOn');
  }

  @override
  Widget build(BuildContext context) {
    AppState _curState = context.findAncestorStateOfType();

    return Drawer(
        child: ListView(children: <Widget>[
          Container(height: 100.0,
              child: DrawerHeader(
                  child: Center(child: Text('Theme Mode Setting')))),
          SwitchListTile(title: Text('Dark Mode'),
              value: _darkOn,
              onChanged: (bool value) {
                setState(() {
                  _darkOn = value;
                  _curState.prefs.setBool('_darkOn', value);
                  _curState.getTheme();
                });
              }
          )
        ],
        ));
  }
}