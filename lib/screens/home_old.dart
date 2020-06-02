import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:location/location.dart';
import 'package:quickfix/models/user.dart';
import 'package:quickfix/screens/dishes.dart';
import 'package:quickfix/services/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/categories.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/content_type.dart';
import 'package:quickfix/util/foods.dart';
import 'package:quickfix/widgets/grid_product.dart';
import 'package:quickfix/widgets/home_category.dart';
import 'package:quickfix/widgets/slider_item.dart';

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

  int _current = 0;
  Location location;
  LocationData locationData;
  List users = List();

  @override
  void initState() {
    location = new Location();
    location.getLocation().then((value) {
      locationData = value;
    });
    location.onLocationChanged.listen((LocationData loc) {
      setState(() {
        locationData = loc;
      });
      getArtisanByLocation();
    });
    getArtisanByLocation();
    super.initState();
  }

  Future<List> getArtisanByLocation() async {
    try {
      final user = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      Map<String, String> headers = {'Bearer': '$apiKey'};
      Map<String, dynamic> body = {
        'mobile': user.phoneNumber,
        'latitude': locationData.latitude,
        'longitude': locationData.longitude
      };
      String url = Constants.getArtisanByLocationUrl;
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      var artisans = response.data['sortedUsers'] as List;
      setState(() {
        users = artisans;
      });
      return artisans;
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Popular Artisans",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FlatButton(
                  child: Text(
                    "View More",
                    style: TextStyle(
                      fontSize: 12,
//                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Aritsans();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 10.0),

            //Slider Here

            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 1.0,
                height: MediaQuery.of(context).size.height / 2.4,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: map<Widget>(
                technicians,
                (index, i) {
                  Map food = technicians[index];
                  return SliderItem(
                    img: food['img'],
                    isFav: true,
                    name: food['name'],
                    rating: 5.0,
                    raters: 23,
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 20.0),

            Text(
              "Jobs Categories",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              height: 65.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categories == null ? 0 : categories.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = categories[index];
                  return HomeCategory(
                    icon: cat['icon'],
                    title: cat['name'],
                    items: cat['items'].toString(),
                    isHome: true,
                  );
                },
              ),
            ),

            SizedBox(height: 20.0),

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
                FlatButton(
                  child: Text(
                    "View More",
                    style: TextStyle(
                      fontSize: 12,
//                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10.0),
            _serviceProvidersAroundMe(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _serviceProvidersAroundMe() {
    return users.isNotEmpty
        ? FutureBuilder(
            future: Utils.getUserSession(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.25),
                      ),
                      itemCount: users == null ? 0 : users.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map technician = users[index];
                        if (technician['profile_pic_file_name'] == '' ||
                            snapshot.data.phoneNumber ==
                                technician['user_mobile']) {
                          users.removeAt(index);
                          return null;
                        } else {
                          return GridProduct(
                            userData: technician,
                            mobile: technician['user_mobile'],
                            img: Constants.uploadUrl +
                                technician['profile_pic_file_name'],
                            isFav: technician['status'] == "verified",
                            name:
                                '${technician['user_first_name']} ${technician['user_last_name']}',
                            rating: 5.0,
                            raters: 23,
                          );
                        }
                      },
                    )
                  : VideoShimmer();
            },
          )
        : VideoShimmer();
  }
}
