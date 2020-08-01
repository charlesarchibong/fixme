import 'package:flutter/material.dart';
import 'package:quickfix/modules/artisan/view/details.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/widgets/smooth_star_rating.dart';

class GridTechnician extends StatelessWidget {
  final String name;
  final String img;
  final int distance;
  final double rating;
  final int raters;
  final String mobile;
  final Map userData;
  final String serviceArea;

  GridTechnician({
    Key key,
    @required this.name,
    @required this.img,
    @required this.distance,
    @required this.rating,
    @required this.raters,
    @required this.mobile,
    @required this.userData,
    this.serviceArea,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                right: 30,
                bottom: 3.0,
                child: Card(
                  elevation: 7,
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        '${distance.toString()}km',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  serviceArea,
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    SmoothStarRating(
                      starCount: 5,
                      borderColor: Constants.ratingBG,
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
                distance: distance,
              );
            },
          ),
        );
      },
    );
  }
}
