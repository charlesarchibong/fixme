import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocation/geolocation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as userLocation;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/flush_bar.dart';
import '../../../helpers/notification.dart';
import '../../../models/failure.dart';
import '../../../services/network/network_service.dart';
import '../../../util/Utils.dart';
import '../../../util/const.dart';
import '../../../util/content_type.dart';
import '../../artisan/provider/artisan_provider.dart';
import '../../artisan/widget/grid_artisans.dart';
import '../../job/provider/approve_bid_provider.dart';
import '../../job/provider/pending_job_provider.dart';
import '../../profile/model/user.dart';

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

  // Location location;
  userLocation.LocationData locationData;
  userLocation.Location location;
  List users = List();
  bool _loadingArtisan = false;
  bool _loadingMoreArtisan = false;
  String phoneNumber = '';
  String accountNumber = '0348861021';
  ScrollController _controller;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("hey i am from the top");
      getMoreArtisanByLocation();
      setState(() {});
    }
  }

  @override
  void initState() {
    getArtisanByLocation();

    location = new userLocation.Location();
    // location.getLocation().then((value) {
    //   locationData = value;
    // });
    location.onLocationChanged.listen((userLocation.LocationData loc) {
      if (mounted)
        setState(() {
          locationData = loc;
          sendLocationToServer(locationData);
        });
    });

    getUserPhone();

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    final requestedProvider = Provider.of<ArtisanProvider>(
      context,
      listen: false,
    );
    getPendingRequest();
    sendDeviceDetails();
    requestedProvider.getMyRequestedService();
    super.initState();
  }

  Future<void> getPendingRequest() async {
    final pendingJobProvider = Provider.of<PendingJobProvider>(
      context,
      listen: false,
    );
    await pendingJobProvider.getPendingRequest();
    final approvedBids = Provider.of<ApprovedBidProvider>(
      context,
      listen: false,
    );
    await approvedBids.getApprovedBids();
  }

  Future sendDeviceDetails() async {
    try {
      final token = await NotificationHelper().getToken();
      String deviceOs;
      String deviceType;
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
        deviceOs = 'Android';
        deviceType =
            androidDeviceInfo.manufacturer + ' - ' + androidDeviceInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
        deviceType = 'IOS ' + iosDeviceInfo.model;
        deviceOs = iosDeviceInfo.systemName;
      }
      final user = await Utils.getUserSession();
      final apiKey = await Utils.getApiKey();
      final String url = Constants.savedDeviceDetails;
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, dynamic> body = {
        'mobile': user.phoneNumber,
        'device_token': token,
        'device_os': deviceOs,
        'device_type': deviceType,
      };
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      Logger().i(response.data);
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      print(e.toString());
    }
  }

  Future sendLocationToServer(userLocation.LocationData locationData) async {
    try {
      final user = await Utils.getUserSession();
      final apiKey = await Utils.getApiKey();
      final String url = Constants.updateLocationUrl;
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, dynamic> body = {
        'mobile': user.phoneNumber,
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
      };
      await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      print(e.toString());
    }
  }

  Future<List> getArtisanByLocation() async {
    try {
      final artisanProvider = Provider.of<ArtisanProvider>(
        context,
        listen: false,
      );

      final GeolocationResult result =
          await Geolocation.isLocationOperational();
      if (result.isSuccessful) {
        // location service is enabled, and location permission is granted
        LocationResult location = await Geolocation.lastKnownLocation();
        double lat = location.location.latitude;
        double lng = location.location.longitude;

        setState(() {
          _loadingArtisan = true;
        });

        final fetched = await artisanProvider.getArtisanByLocation(lat, lng);
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
      } else {
        throw Exception('${result.error.message}');
      }
    } catch (error) {
      setState(() {
        users = null;
      });
      // getArtisanByLocation();
      print(error.toString());
      FlushBarCustomHelper.showErrorFlushbar(
        context,
        'Error',
        'An error occured, please on your location service and click on the refresh to load artisans',
      );

      return List();
    }
  }

  Future getMoreArtisanByLocation() async {
    try {
      final artisanProvider = Provider.of<ArtisanProvider>(
        context,
        listen: false,
      );
      print("hey i am runninf");
      setState(() {
        _loadingMoreArtisan = true;
      });

      var highestId = users.length + 1;
      print(highestId);

      final fetched = await artisanProvider.getMoreArtisanByLocation(
          locationData: locationData, highestId: highestId.toString());
      fetched.fold((Failure failure) {
        setState(() {
          _loadingMoreArtisan = false;
          users = users;
        });
        return List();
      }, (List listArtisan) {
        List newList = [];
        if (highestId == users.length + 1) {
          print(" yo man");
          newList = [...users, ...listArtisan];
          setState(() {
            _loadingMoreArtisan = false;
            users = newList;
          });
        }
      });

      highestId = users.length + 1;
    } catch (error) {
      setState(() {
        _loadingMoreArtisan = false;
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
        systemNavigationBarColor: Color.fromRGBO(153, 0, 153, 1.0),
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
                    'We are so sorry, no artisan available near your location. Please ensure that your device location is on and click the button below to refresh',
                    style: TextStyle(
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
