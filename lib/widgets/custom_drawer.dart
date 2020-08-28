import 'package:flutter/material.dart';
import '../app.dart';


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
                  child: Center(child: Text('Theme Mode')))),
          SwitchListTile(title: Text('Dark Mode'),
              value: _darkOn,
              onChanged: (bool value) {
                setState(() {
                  _darkOn = value;
                  _curState.prefs.setBool('_darkOn', value);
                  _curState.getTheme();
                });
              },
              activeTrackColor: Colors.purple[300],
              activeColor: Colors.purple,
          )
        ],
        ));
  }
}