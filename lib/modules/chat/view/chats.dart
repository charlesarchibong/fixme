import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickfix/modules/chat/widget/my_chats_widget.dart';
import 'package:quickfix/util/foods.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  void initState() {
    super.initState();
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
          IconButton(
            color: Colors.white,
            icon: Badge(
              badgeContent: Text(
                '3',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              badgeColor: Colors.white,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              child: FaIcon(
                FontAwesomeIcons.comment,
                size: 17.0,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Chats(),
                ),
              );
            },
            tooltip: "Chats",
          ),
          // IconButton(
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
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: technicians.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    // Map artisan = technicians[index];
                    return MyChatWidget(
                      artisan: technicians[index],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
