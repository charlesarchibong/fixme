import 'package:flutter/material.dart';
import 'package:quickfix/screens/details.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/widgets/smooth_star_rating.dart';

class GridTechnician extends StatelessWidget {
  final String name;
  final String img;
  final bool isFav;
  final double rating;
  final int raters;
  final String mobile;
  final Map userData;

  GridTechnician({
    Key key,
    @required this.name,
    @required this.img,
    @required this.isFav,
    @required this.rating,
    @required this.raters,
    @required this.mobile,
    @required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3.6,
                width: MediaQuery.of(context).size.width / 2.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    "$img",
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
                  child: isFav
                      ? Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 35,
                        )
                      : Text(''),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 2.0, top: 8.0),
            child: Text(
              "$name",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
            child: Row(
              children: <Widget>[
                SmoothStarRating(
                  starCount: 5,
                  color: Constants.ratingBG,
                  allowHalfRating: true,
                  rating: rating,
                  size: 10.0,
                ),
                Text(
                  " $rating ($raters Reviews)",
                  style: TextStyle(
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductDetails(
                userData: userData,
              );
            },
          ),
        );
      },
    );
  }
}