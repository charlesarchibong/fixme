import 'package:flutter/material.dart';

class CustomPopupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        print(value);
        if (value == 4) {}
      },
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.check,
                color: Colors.green,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text('Accept Request'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text('Decline Request'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.remove_red_eye,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text('View Details'),
            ],
          ),
        ),
      ],
    );
  }
}
