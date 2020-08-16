import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/firebase/messages.dart';
import '../../../util/Utils.dart';
import '../../profile/model/user.dart';
import '../widget/my_chats_widget.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  User currentUser;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    final user = await Utils.getUserSession();
    setState(() {
      currentUser = user;
      print(currentUser.toJson());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(153, 0, 153, 1),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            "Chats",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            // IconButton(
            //   color: Colors.white,
            //   icon: Badge(
            //     badgeContent: Text(
            //       '3',
            //       style: TextStyle(
            //         color: Colors.black,
            //       ),
            //     ),
            //     badgeColor: Colors.white,
            //     animationType: BadgeAnimationType.slide,
            //     toAnimate: true,
            //     child: FaIcon(
            //       FontAwesomeIcons.comment,
            //       size: 17.0,
            //     ),
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (_) => Chats(),
            //       ),
            //     );
            //   },
            //   tooltip: "Chats",
            // ),
            // // IconButton(
            //   color: Colors.white,
            //   icon: Badge(
            //     badgeContent: Text(
            //       '2',
            //       style: TextStyle(
            //         color: Colors.black,
            //       ),
            //     ),
            //     badgeColor: Colors.white,
            //     animationType: BadgeAnimationType.slide,
            //     toAnimate: true,
            //     child: FaIcon(
            //       FontAwesomeIcons.bell,
            //       size: 17.0,
            //     ),
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (BuildContext context) {
            //           return Notifications();
            //         },
            //       ),
            //     );
            //   },
            //   tooltip: "Notifications",
            // ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: currentUser == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: MessageService().getUserChats(),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount:
                                        snapshot.data?.documents?.length ?? 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // Map artisan = technicians[index];
                                      return MyChatWidget(
                                        message: snapshot
                                            .data.documents[index].documentID,
                                        me: '${currentUser.phoneNumber}',
                                      );
                                    },
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                          }),
                    ),
                  ],
                ),
        ));
  }

  // List<Message> _convertMessageToListStream(QuerySnapshot querySnapshot) {
  //   return querySnapshot.documents
  //       .map((doc) => Message.fromMap(doc.data))
  //       .toList();
  // }
}
