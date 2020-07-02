import 'package:flutter/material.dart';

class MyChatWidget extends StatefulWidget {
  final Map artisan;

  const MyChatWidget({Key key, this.artisan}) : super(key: key);
  @override
  _MyChatWidgetState createState() => _MyChatWidgetState();
}

class _MyChatWidgetState extends State<MyChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.artisan['read'] ? Colors.white : Colors.white70,
      child: ListTile(
        onTap: () {},
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          backgroundImage: AssetImage(widget.artisan['img']),
        ),
        title: Text(
          widget.artisan['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: Text(widget.artisan['message']),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('3:70PM'),
            Spacer(),
            widget.artisan['read']
                ? Text('')
                : Icon(
                    Icons.mail,
                    color: Theme.of(context).accentColor,
                    size: 18.0,
                  )
          ],
        ),
      ),
    );
  }
}
