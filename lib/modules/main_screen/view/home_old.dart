import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  String phoneNumber = '';
  String accountNumber = '0348861021';
  // final TextEditingController _searchControl = new TextEditingController();

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
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),

                //Slider Here

                // CarouselSlider(
                //   options: CarouselOptions(
                //     autoPlay: true,
                //     viewportFraction: 1.0,
                //     height: MediaQuery.of(context).size.height / 2.4,
                //     onPageChanged: (index, reason) {
                //       setState(() {
                //         _current = index;
                //       });
                //     },
                //   ),
                //   items: map<Widget>(
                //     technicians,
                //     (index, i) {
                //       Map food = technicians[index];
                //       return SliderItem(
                //         img: food['img'],
                //         isFav: true,
                //         name: food['name'],
                //         rating: 5.0,
                //         raters: 23,
                //       );
                //     },
                //   ).toList(),
                // ),
                // SizedBox(height: 20.0),

                // Text(
                //   "Search Service or Business",
                //   style: TextStyle(
                //     fontSize: 19,
                //     fontWeight: FontWeight.w800,
                //   ),
                // ),
                // Container(
                //   height: 65.0,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     shrinkWrap: true,
                //     itemCount: categories == null ? 0 : categories.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       Map cat = categories[index];
                //       return HomeCategory(
                //         icon: cat['icon'],
                //         title: cat['name'],
                //         items: cat['items'].toString(),
                //         isHome: true,
                //       );
                //     },
                //   ),
                // ),
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
                                        style: TextStyle(
                                          color: snapshot.hasData
                                              ? snapshot.data
                                                          .getString("theme") ==
                                                      'light'
                                                  ? Colors.black
                                                  : Colors.white
                                              : Colors.white,
                                          fontSize: 17,
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
                                            style: TextStyle(
                                              // color: Theme.of(context).primaryColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
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
        ? GridView.builder(
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
              return GridTechnician(
                userData: technician,
                mobile: technician['user_mobile'],
                img: Constants.uploadUrl + technician['profile_pic_file_name'],
                distance: technician['distance'],
                name:
                    '${technician['user_first_name']} ${technician['user_last_name']}',
                rating: double.parse(
                      technician['user_rating'].toString(),
                    ) ??
                    0.0,
                raters: technician['reviews'] ?? 0,
                serviceArea: technician['service_area'],
              );
            },
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
