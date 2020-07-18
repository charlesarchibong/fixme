import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickfix/modules/chat/model/message.dart';
import 'package:quickfix/modules/chat/view/chat_screen.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/firebase/messages.dart';
import 'package:quickfix/services/firebase/users.dart';

class MyChatWidget extends StatefulWidget {
  final String message;
  final String me;

  const MyChatWidget({Key key, this.message, this.me}) : super(key: key);
  @override
  _MyChatWidgetState createState() => _MyChatWidgetState();
}

class _MyChatWidgetState extends State<MyChatWidget> {
  final df = new DateFormat('dd-MMM hh:mm a');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: MessageService().getMyChats(widget.message),
        builder: (context, snapshot) {
          Message message = Message.fromMap(snapshot.data.documents.first.data);
          print(message.toMap());
          return Card(
            // color: widget.artisan['read'] ? Colors.white : Colors.white70,
            child: StreamBuilder<User>(
                stream: UsersService(
                  userPhone: message.receiverPhone == widget.me
                      ? message.senderPhone
                      : message.receiverPhone,
                ).user,
                builder: (context, user) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            receiver: message.receiverPhone,
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage: user.data.imageUrl == null
                          ? AssetImage(
                              'assets/dp.png',
                            )
                          : NetworkImage(
                              user.data.imageUrl,
                            ),
                    ),
                    title: Text(
                      '${user.data.firstName + ' ' + user.data.lastName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                      '${message.senderPhone == widget.me ? 'Me:' : ''} ${message.text}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '${df.format(DateTime.fromMillisecondsSinceEpoch(message.time, isUtc: false))}',
                        ),
                        Spacer(),
                        message.unread == false
                            ? Icon(
                                Icons.mail,
                                color: Theme.of(context).accentColor,
                                size: 18.0,
                              )
                            : Text('')
                      ],
                    ),
                  );
                }),
          );
        });
  }
}
