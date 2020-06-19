import 'package:flutter/material.dart';
import 'package:quickfix/modules/job/model/job.dart';

class CustomPopupButton extends StatelessWidget {
  final Job job;

  const CustomPopupButton({Key key, this.job}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          print('bby');
        }
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
              Text('Bid'),
            ],
          ),
        ),
      ],
    );
  }
}
