import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickfix/modules/notification/view/notifications.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/widgets/badge.dart';
import 'package:quickfix/widgets/reviews.dart';
import 'package:quickfix/widgets/smooth_star_rating.dart';

class ProductDetails extends StatefulWidget {
  final Map userData;

  const ProductDetails({Key key, this.userData}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
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
          "Artisan's Profile",
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
                  builder: (BuildContext context) {
                    return;
                  },
                ),
              );
            },
            tooltip: "Chats",
          ),
          IconButton(
            color: Colors.white,
            icon: Badge(
              badgeContent: Text(
                '2',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              badgeColor: Colors.white,
              animationType: BadgeAnimationType.slide,
              toAnimate: true,
              child: FaIcon(
                FontAwesomeIcons.bell,
                size: 17.0,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Notifications();
                  },
                ),
              );
            },
            tooltip: "Notifications",
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3.2,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "${Constants.uploadUrl + widget.userData['profile_pic_file_name']}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: -10.0,
                  bottom: 3.0,
                  child: RawMaterialButton(
                    onPressed: () {},
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: widget.userData['status'] == "verified"
                          ? Icon(
                              Icons.verified_user,
                              color: Colors.red,
                              size: 35,
                            )
                          : Text(''),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              "${widget.userData['user_first_name']} ${widget.userData['user_last_name']} (${widget.userData['service_area']})",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: <Widget>[
                  SmoothStarRating(
                    starCount: 5,
                    color: Constants.ratingBG,
                    allowHalfRating: true,
                    rating: 5.0,
                    size: 10.0,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    "5.0 (23 Reviews)",
                    style: TextStyle(
                      fontSize: 11.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "20 Stars",
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 20.0),
            // Text(
            //   "Bio",
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.w800,
            //   ),
            //   maxLines: 2,
            // ),
            // SizedBox(height: 10.0),
            // Text(
            //   "Am a skilled electrician with over 8 years of experience."
            //   "I have over the years aided in the wiring of over 30 houses. "
            //   "I do general repairs also and I have a flair for paying attention to details. "
            //   "I am also self sufficient which means I can make rational decisions when necessary. Can’t wait to work with you.",
            //   style: TextStyle(
            //     fontSize: 13,
            //     fontWeight: FontWeight.w300,
            //   ),
            // ),
            SizedBox(height: 10.0),
            Text(
              "Subservices Offered",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 10.0),
            Text(
              "${widget.userData['service_area']}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Reviews",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20.0),
            Reviews(),
            SizedBox(height: 10.0),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 30.0, left: 20.0, right: 20.0),
        child: Container(
          height: 50.0,
          child: RaisedButton(
            child: Text(
              "Request Service",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
