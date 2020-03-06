import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;
  final String description;
  Alert({Key key, @required this.title, @required this.description})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text(this.description)],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
