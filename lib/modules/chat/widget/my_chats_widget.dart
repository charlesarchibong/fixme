import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
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

  bool isForMe(String node, String myPhone) {
    String node1 = node.split('-')[0];
    String node2 = node.split('-')[1];
    return node1 == myPhone || node2 == myPhone;
  }

  @override
  Widget build(BuildContext context) {
    return isForMe(widget.message, widget.me)
        ? StreamBuilder<QuerySnapshot>(
            stream: MessageService().getMyChats(widget.message, widget.me),
            builder: (context, snapshot) {
              Message message = Message.fromMap(
                snapshot.data?.documents?.first?.data,
              );
              return message == null
                  ? Text('')
                  : Card(
                      // color: widget.artisan['read'] ? Colors.white : Colors.white70,
                      child: StreamBuilder<User>(
                          stream: UsersService(
                            userPhone: message.receiverPhone == widget.me
                                ? message.senderPhone
                                : message.receiverPhone,
                          ).user,
                          builder: (context, user) {
                            // print(
                            //   user.data.,
                            // );
                            return user.hasData
                                ? ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ChatScreen(
                                            receiverToken:
                                                user.data.firebaseToken,
                                            receiver: message.receiverPhone ==
                                                    widget.me
                                                ? message.senderPhone
                                                : message.receiverPhone,
                                          ),
                                        ),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      backgroundImage: user.data != null
                                          ? NetworkImage(
                                              user.data.profilePicture,
                                            )
                                          : AssetImage('assets/dp.png'),
                                    ),
                                    title: Text(
                                      // ignore: null_aware_before_operator
                                      '${user.data?.firstName} ${user.data?.lastName}',
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${df.format(DateTime.fromMillisecondsSinceEpoch(message.time, isUtc: false))}',
                                        ),
                                        Spacer(),
                                        message.senderPhone == widget.me
                                            ? Text('')
                                            : message.unread == false
                                                ? Text(
                                                    'NEW',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      fontSize: 15.0,
                                                    ),
                                                  )
                                                : Text('')
                                      ],
                                    ),
                                  )
                                : ListTileShimmer();
                          }),
                    );
            })
        : Text('');
  }
}
