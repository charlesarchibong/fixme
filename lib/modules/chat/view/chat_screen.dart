import 'package:flutter/material.dart';
import 'package:quickfix/modules/chat/model/message.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/util/Utils.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  ChatScreen({this.user});

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
            message.time,
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
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await Utils.getUserSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).accentColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: AssetImage('assets/food1.jpeg'),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              'Charles Archibong',
              style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
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
              child: Container(
                decoration: BoxDecoration(
                    // color: Colors.white,
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(30.0),
                    //   topRight: Radius.circular(30.0),
                    // ),
                    ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: ListView.builder(
                    reverse: false,
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      final Message message = Message(
                        isLiked: true,
                        sender: currentUser,
                        text: messageList[index],
                        time: '14:90',
                        unread: false,
                      );
                      final bool isMe = isMeList[index];
                      return _buildMessage(message, isMe);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
