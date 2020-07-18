import 'package:flutter/material.dart';

class MyChatWidget extends StatefulWidget {
  final String message;

  const MyChatWidget({Key key, this.message}) : super(key: key);
  @override
  _MyChatWidgetState createState() => _MyChatWidgetState();
}

class _MyChatWidgetState extends State<MyChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.message);
    // return Card(
    //   // color: widget.artisan['read'] ? Colors.white : Colors.white70,
    //   child: ListTile(
    //     onTap: () {
    //       Navigator.of(context).push(
    //         MaterialPageRoute(
    //           builder: (_) => ChatScreen(
    //             receiver: widget.message.receiverPhone,
    //           ),
    //         ),
    //       );
    //     },
    //     leading: CircleAvatar(
    //       backgroundColor: Theme.of(context).primaryColor,
    //       backgroundImage: AssetImage('assets/dp.png'),
    //     ),
    //     title: Text(
    //       'Charles Archibong',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         fontSize: 18.0,
    //       ),
    //     ),
    //     subtitle: Text(widget.message.text),
    //     trailing: Column(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       children: <Widget>[
    //         Text(widget.message.time.toString()),
    //         Spacer(),
    //         widget.message.unread == false
    //             ? Text('')
    //             : Icon(
    //                 Icons.mail,
    //                 color: Theme.of(context).accentColor,
    //                 size: 18.0,
    //               )
    //       ],
    //     ),
    //   ),
    // );
  }
}
