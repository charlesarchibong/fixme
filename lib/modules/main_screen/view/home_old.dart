import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/artisan/provider/artisan_provider.dart';
import 'package:quickfix/modules/artisan/widget/grid_artisans.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeW extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeW>
    with AutomaticKeepAliveClientMixin<HomeW> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  // int _current = 0;
  Location location;
  LocationData locationData;
  List users = List();
  bool _loadingArtisan = false;
  bool _loadingMoreArtisan = false;
  String phoneNumber = '';
  String accountNumber = '0348861021';
  ScrollController _controller;
  // final TextEditingController _searchControl = new TextEditingController();
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      getMoreArtisanByLocation();
      setState(() {
        // message = "reach the bottom";
      });
    }
  }

  @override
  void initState() {
    location = new Location();
    location.getLocation().then((value) {
      locationData = value;
    });
    location.onLocationChanged.listen((LocationData loc) {
      if (mounted)
        setState(() {
          locationData = loc;
        });
      // getArtisanByLocation();
    });
    Future.delayed(
        Duration(
          seconds: 10,
        ), () {
      getArtisanByLocation();
    });
    getUserPhone();

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  Future<List> getArtisanByLocation() async {
    try {
      final artisanProvider = Provider.of<ArtisanProvider>(
        context,
        listen: false,
      );
      setState(() {
        _loadingArtisan = true;
      });

      final fetched = await artisanProvider.getArtisanByLocation(locationData);
      setState(() {
        _loadingArtisan = false;
      });
      return fetched.fold((Failure failure) {
        setState(() {
          users = List();
        });
        return List();
      }, (List listArtisan) {
        setState(() {
          users = listArtisan;
        });
        return listArtisan;
      });
    } catch (error) {
      setState(() {
        users = List();
      });

      print(error.toString());
      return List();
    }
  }

  // ************************** get more users *****************************************************
  Future<List> getMoreArtisanByLocation() async {
    try {
      final artisanProvider = Provider.of<ArtisanProvider>(
        context,
        listen: false,
      );
      setState(() {
        _loadingMoreArtisan = true;
      });

      var highestId = users.length + 1;
      print(highestId);

      final fetched = await artisanProvider.getMoreArtisanByLocation(
          locationData: locationData, highestId: highestId);
      return fetched.fold((Failure failure) {
        setState(() {
          _loadingMoreArtisan = false;
          users = users;
        });
        return List();
      }, (List listArtisan) {
        List newList = [...users, ...listArtisan];
        setState(() {
          _loadingMoreArtisan = false;
          users = newList;
        });
        return newList;
      });
    } catch (error) {
      print(error.toString());
      return List();
    }
  }

  Future getUserPhone() async {
    final user = await Utils.getUserSession();
    setState(() {
      phoneNumber = user.phoneNumber;
      accountNumber = user.accountNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            Color.fromRGBO(153, 0, 153, 1.0), // navigation bar color
        statusBarColor: Color.fromRGBO(153, 0, 153, 1.0),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => getArtisanByLocation(),
        child: SingleChildScrollView(
          controller: _controller,
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                InkWell(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: accountNumber,
                      ),
                    );
                    FlushBarCustomHelper.showInfoFlushbar(
                      context,
                      accountNumber,
                      'Copied to clipboard',
                    );
                  },
                  child: FutureBuilder<SharedPreferences>(
                      future: SharedPreferences.getInstance(),
                      builder: (context, snapshot) {
                        return FutureBuilder<User>(
                            future: Utils.getUserSession(),
                            builder: (context, usersnapshot) {
                              return Card(
                                color: Colors.white,
                                elevation: 6.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'Your account number is ',
                                        style: GoogleFonts.solway(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                          ),
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: usersnapshot.hasData
                                                ? '${usersnapshot.data.accountNumber}'
                                                : '',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                    text: usersnapshot
                                                        .data.accountNumber,
                                                  ),
                                                );
                                                FlushBarCustomHelper
                                                    .showInfoFlushbar(
                                                  context,
                                                  usersnapshot
                                                      .data.accountNumber,
                                                  'Copied to clipboard',
                                                );
                                              },
                                          ),
                                          TextSpan(
                                            text:
                                                '. Bank Name is Providus Bank. To receive/send money simply transfer to this account.',
                                            style: GoogleFonts.solway(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }),
                ),
                // SizedBox(
                //   height: 6,
                // ),
                // InkWell(
                //   onTap: () {
                //     print('bby');
                //   },
                //   child: Card(
                //     elevation: 6.0,
                //     child: Container(
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(5.0),
                //         ),
                //       ),
                //       child: TextField(
                //         style: TextStyle(
                //           fontSize: 15.0,
                //           color: Colors.black,
                //         ),
                //         decoration: InputDecoration(
                //           contentPadding: EdgeInsets.all(10.0),
                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(5.0),
                //             borderSide: BorderSide(
                //               color: Colors.white,
                //             ),
                //           ),
                //           enabledBorder: OutlineInputBorder(
                //             borderSide: BorderSide(
                //               color: Colors.white,
                //             ),
                //             borderRadius: BorderRadius.circular(5.0),
                //           ),
                //           hintText: "Search Service Providers or Businesses",
                //           suffixIcon: IconButton(
                //             onPressed: () {
                //               // _searchArtisans(_searchControl.text);
                //             },
                //             icon: Icon(
                //               Icons.search,
                //               color: Colors.black,
                //             ),
                //           ),
                //           hintStyle: TextStyle(
                //             fontSize: 15.0,
                //             color: Colors.black,
                //           ),
                //         ),
                //         maxLines: 1,
                //         controller: _searchControl,
                //         onSubmitted: (val) {
                //           // _searchArtisans(val);
                //         },
                //       ),
                //     ),
                //   ),
                // ),

                SizedBox(height: 10.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Service Providers",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
//                 FlatButton(
//                   child: Text(
//                     "voew more",
//                     style: TextStyle(
//                       fontSize: 12,
// //                      fontWeight: FontWeight.w800,
//                       color: Theme.of(context).accentColor,
//                     ),
//                   ),
//                   onPressed: () {},
//                 ),
                  ],
                ),
                SizedBox(height: 10.0),
                _loadingArtisan
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _serviceProvidersAroundMe(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _serviceProvidersAroundMe() {
    return users != null
        ? AnimationLimiter(
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  primary: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.1),
                  ),
                  itemCount: users == null ? 0 : users.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map technician = users[index];
                    // print(technician['id']);
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 2,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GridTechnician(
                            userData: technician,
                            mobile: technician['user_mobile'],
                            img: Constants.uploadUrl +
                                technician['profile_pic_file_name'],
                            distance: technician['distance'],
                            name:
                                '${technician['user_first_name']} ${technician['user_last_name']}',
                            rating: double.parse(
                                  technician['user_rating'].toString(),
                                ) ??
                                0.0,
                            raters: technician['reviews'] ?? 0,
                            serviceArea: technician['service_area'],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                _loadingMoreArtisan
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          )
        : Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/sad.svg',
                    semanticsLabel: 'So Sad',
                    width: 250,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'We are so sorry, no artisan available near your location.',
                    style: TextStyle(
                      // color: Theme.of(context).accentColor,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    child: Text(
                      "Click here to Refresh",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () async {
                      getArtisanByLocation();
                    },
                  ),
                ],
              ),
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
