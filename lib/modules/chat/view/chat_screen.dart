import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:quickfix/helpers/custom_lodder.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/modules/chat/model/message.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/firebase/messages.dart';
import 'package:quickfix/services/firebase/users.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';

class ChatScreen extends StatefulWidget {
  final String receiver;
  final String receiverToken;

  ChatScreen({@required this.receiver, this.receiverToken});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User currentUser;
  List isMeList = [false, true, false];
  List messageList = [
    'Hi Charles',
    'Good morning, how are you?',
    'I am fine and you?'
  ];

  // final _formKey = GlobalKey<FormState>();

  TextEditingController _messageController = TextEditingController();

  final df = new DateFormat('dd-MMM-yyyy hh:mm a');

  _buildMessage(Message message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Color.fromRGBO(153, 0, 153, .75) : Colors.grey[400],
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${df.format(DateTime.fromMillisecondsSinceEpoch(message.time, isUtc: false))}',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        IconButton(
          icon: message.isLiked
              ? Icon(
                  Icons.favorite,
                )
              : Icon(
                  Icons.favorite_border,
                ),
          iconSize: 30.0,
          color: message.isLiked ? Colors.grey : Colors.grey[100],
          onPressed: () {},
        )
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      height: 70.0,
      // color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.photo,
            ),
            iconSize: 25.0,
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: _messageController,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
            ),
            iconSize: 25.0,
            color: Theme.of(context).accentColor,
            onPressed: () {
              sendMessage(_messageController.text);
            },
          ),
        ],
      ),
    );
  }

  void sendMessage(String messageText) async {
    try {
      _messageController.clear();
      String messageId = Utils.generateId(30);

      Message message = Message(
        id: getChatNode(
          currentUser.phoneNumber,
          widget.receiver,
        ),
        isLiked: false,
        receiverPhone: widget.receiver,
        senderPhone: currentUser.phoneNumber,
        text: messageText,
        time: DateTime.now().millisecondsSinceEpoch,
        unread: false,
      );
      await MessageService(messageId: messageId).updateMessage(message);
      sendAndRetrieveMessage(1);

      //Message Count
      FlutterAppBadger.updateBadgeCount(1);

      // FocusScope.of(context).requestFocus(FocusNode());

    } catch (e) {
      Logger().e(e);
      FlushBarCustomHelper.showErrorFlushbar(
        context,
        'Error',
        'Your message was not sent',
      );
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    final user = await Utils.getUserSession();
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).accentColor,
        title: StreamBuilder<User>(
            stream: UsersService(userPhone: widget.receiver).user,
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    backgroundImage: NetworkImage(snapshot.data.profilePicture),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    '${snapshot.data.firstName ?? ''} ${snapshot.data.lastName ?? ''}',
                    style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              );
            }),
        elevation: 0.0,
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.more_horiz),
          //   iconSize: 30.0,
          //   color: Colors.white,
          //   onPressed: () {},
          // ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: currentUser == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          // color: Colors.white,
                          // borderRadius: BorderRadius.only(
                          //   topLeft: Radius.circular(30.0),
                          //   topRight: Radius.circular(30.0),
                          // ),
                          ),
                      child: ClipRRect(
                        child: StreamBuilder<List<Message>>(
                            stream: MessageService().getMessages(
                              currentUser.phoneNumber,
                              widget.receiver,
                            ),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? ListView.builder(
                                      reverse: true,
                                      padding: EdgeInsets.only(top: 15.0),
                                      itemCount: snapshot.data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final Message message =
                                            snapshot.data[index];
                                        final bool isMe = message.senderPhone ==
                                            currentUser.phoneNumber;
                                        return _buildMessage(message, isMe);
                                      },
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    );
                            }),
                      ),
                    ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<Map<String, dynamic>> sendAndRetrieveMessage(unReadMSGCount) async {
    var firebaseCloudserverToken = DotEnv().env[FCM_KEY];
    final response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$firebaseCloudserverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '${_messageController.text}',
            'title': '${currentUser.firstName} ${currentUser.lastName}',
            'badge': '$unReadMSGCount' //'$unReadMSGCount'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'chatroomid': getChatNode(currentUser.phoneNumber, widget.receiver),
          },
          'to': widget.receiverToken,
        },
      ),
    );

    CustomLogger(className: 'ChatScreen').messagePrint(response.body);

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
    // FocusScope.of(context).requestFocus(FocusNode());

    return completer.future;
  }

  String getChatNode(String sender, String receiver) {
    if (sender.hashCode <= receiver.hashCode) {
      return sender + '-' + receiver;
    } else {
      return receiver + '-' + sender;
    }
  }
}
