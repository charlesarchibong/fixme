import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/flush_bar.dart';
import '../../../models/failure.dart';
import '../../../util/const.dart';
import '../../../widgets/reviews.dart';
import '../../../widgets/smooth_star_rating.dart';
import '../../chat/view/chat_screen.dart';
import '../../profile/provider/profile_provider.dart';
import '../provider/artisan_provider.dart';

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
  bool _loadingReviews = true;
  List artisanReviews;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    updateArtisanProfileView();
    getReviews();
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
    if (mounted) {
      setState(() {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
        FlutterStatusbarcolor.setStatusBarColor(
            Color.fromRGBO(153, 0, 153, 1.0));
        FlutterStatusbarcolor.setNavigationBarColor(
          Color.fromRGBO(153, 0, 153, 1.0),
        );
      });
    }
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

  void getReviews() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    final reviews = await profileProvider.getArtisanReview(
      widget.userData['user_mobile'],
    );

    setState(() {
      _loadingReviews = false;
      artisanReviews = reviews;
    });
    // artisanReviews = ReviewList.fromData(reviews).reviewList;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userData);
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
          //         builder: (BuildContext context) {
          //           return;
          //         },
          //       ),
          //     );
          //   },
          //   tooltip: "Chats",
          // ),
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
                Hero(
                  transitionOnUserGestures: true,
                  tag: '${widget.userData['id']}',
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext con) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height: 500,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: CacheImage(
                                  '${Constants.uploadUrl + widget.userData['profile_pic_file_name']}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image(
                          image: CacheImage(
                            "${Constants.uploadUrl + widget.userData['profile_pic_file_name']}",
                          ),
                          fit: BoxFit.fitWidth,
                          alignment: FractionalOffset.topCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: 3.0,
                  child: Card(
                    color: Colors.white,
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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                    ],
                  ),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    var url = "tel:0${widget.userData['user_mobile']}";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  // backgroundColor: Colors.green,
                  child: Icon(Icons.phone),
                ),
              ],
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

            SizedBox(height: 10.0),
            Text(
              "Service Pictures",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 10.0),
            Container(
              height: 80,
              child: widget.userData["servicePictures"].length > 0
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.userData["servicePictures"].length,
                      itemBuilder: (context, index) {
                        String image = Constants.uploadUrl +
                            widget.userData["servicePictures"][index];
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext con) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  height: 500,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              width: 100,
                              height: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CacheImage(image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No service picture available yet",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
            _loadingReviews
                ? Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Reviews(
                    reviews: artisanReviews,
                  ),
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
              Consumer<ArtisanProvider>(
                builder: (context, artisanProvider, child) {
                  return artisanProvider.loading
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
                            final requested = await artisanProvider.request(
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
              // FloatingActionButton(
              //   onPressed: () async {
              //     var url = "tel:0${widget.userData['user_mobile']}";
              //     if (await canLaunch(url)) {
              //       await launch(url);
              //     } else {
              //       throw 'Could not launch $url';
              //     }
              //   },
              //   // backgroundColor: Colors.green,
              //   child: Icon(Icons.phone),
              // ),
              // Spacer(),
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
