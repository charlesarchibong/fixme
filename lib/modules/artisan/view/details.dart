import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/artisan/provider/artisan_provider.dart';
import 'package:quickfix/modules/chat/view/chat_screen.dart';
import 'package:quickfix/modules/profile/provider/profile_provider.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/widgets/reviews.dart';
import 'package:quickfix/widgets/smooth_star_rating.dart';

class ProductDetails extends StatefulWidget {
  final Map userData;
  final int distance;

  const ProductDetails({Key key, this.userData, this.distance})
      : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with WidgetsBindingObserver {
  bool isFav = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    updateArtisanProfileView();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setStatusBar();
  }

  void setStatusBar() async {
    setState(() {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
      FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(153, 0, 153, 1.0));
      FlutterStatusbarcolor.setNavigationBarColor(
        Color.fromRGBO(153, 0, 153, 1.0),
      );
    });
  }

  void updateArtisanProfileView() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    print(widget.userData);
    final updated = await profileProvider.updateProfileView(
      widget.userData['user_mobile'],
    );
    updated.fold(
      (Failure failure) => print(failure.message),
      (r) => print('profile view count updated'),
    );
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
                  right: 30,
                  bottom: 3.0,
                  child: Card(
                    elevation: 7,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          '${widget.distance.toString()}km',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                    borderColor: Constants.ratingBG,
                    rating: double.parse(
                      widget.userData['user_rating'].toString(),
                    ),
                    size: 10.0,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    "(${widget.userData['reviews']} Reviews)",
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
                    "${widget.userData['user_rating']} Stars",
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
        padding: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
        child: Container(
          height: 50.0,
          child: Row(
            children: <Widget>[
              Consumer<RequestArtisanService>(
                builder: (context, requestArtisanService, child) {
                  return requestArtisanService.loading
                      ? Container(
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          child: Text(
                            "Request Service",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () async {
                            final requested =
                                await requestArtisanService.request(
                              widget.userData['user_mobile'],
                            );
                            requested.fold((Failure failure) {
                              FlushBarCustomHelper.showErrorFlushbar(
                                context,
                                'Error',
                                failure.message,
                              );
                            }, (bool requested) {
                              FlushBarCustomHelper.showInfoFlushbar(
                                context,
                                'Success',
                                'Request was successfully, please wait for Artisan to confirm his/her availability.',
                              );
                            });
                          },
                        );
                },
              ),
              Spacer(),
              RaisedButton(
                child: Text(
                  "Send Message",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        receiver: widget.userData['user_mobile'],
                        receiverToken: widget.userData['mobile_device_token'],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
