import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/artisan/view/details.dart';
import 'package:quickfix/modules/search/provider/search_provider.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/widgets/smooth_star_rating.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  final TextEditingController _searchControl = new TextEditingController();
  bool _loading = false;
  String defaultMsg = 'Please enter a name to search for service providers';
  List _artisans = List();
  String error = '';

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Center(
              child: Text(
                "Search Artisan",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Card(
              elevation: 6.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextField(
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Search Artisan...",
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchArtisans(_searchControl.text);
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  maxLines: 1,
                  controller: _searchControl,
                  onSubmitted: (val) {
                    _searchArtisans(val);
                  },
                ),
              ),
            ),
            SizedBox(height: 5.0),
            _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : error.isNotEmpty
                    ? Center(
                        child: Text(error),
                      )
                    : _artisans.length > 0
                        ? Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "Results",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    _artisans == null ? 0 : _artisans.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map artisan = _artisans[index];
                                  return ListTile(
                                    title: Text(
                                      "${artisan['user_first_name']} ${artisan['user_last_name']}",
                                      style: TextStyle(
                                        //                    fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      radius: 25.0,
                                      backgroundImage: NetworkImage(
                                        "${Constants.uploadUrl + artisan['profile_pic_file_name']}",
                                      ),
                                    ),
                                    trailing: SmoothStarRating(
                                      starCount: 1,
                                      color: Constants.ratingBG,
                                      allowHalfRating: true,
                                      rating: 5.0,
                                      size: 12.0,
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(width: 6.0),
                                            Text(
                                              "5.0 (${artisan['reviews']} Reviews)",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6.0),
                                        Text(
                                          "Distance - ${artisan['distance']}km",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return ProductDetails(
                                                userData: artisan,
                                                distance: artisan['distance']);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          )
                        : Text(''),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _searchArtisans(String keyword) async {
    setState(() {
      _loading = true;
    });
    final searchProvider = Provider.of<SearchProvider>(
      context,
      listen: false,
    );
    final fetched = await searchProvider.searchArtisan(keyword);
    if (fetched == null) {
      setState(() {
        _loading = false;
      });
      FlushBarCustomHelper.showErrorFlushbar(
        context,
        'Error',
        'No artisan information retrieved, please try again',
      );
    } else {
      fetched.fold((Failure failure) {
        setState(() {
          _loading = false;
        });
        FlushBarCustomHelper.showErrorFlushbar(
          context,
          'Error',
          failure.message,
        );
      }, (List artisans) {
        if (artisans.length <= 0) {
          setState(() {
            error = 'No artisan found, please search again';
          });
        } else {
          setState(() {
            error = '';
          });
        }
        setState(() {
          _loading = false;
          _artisans = artisans;
        });
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
