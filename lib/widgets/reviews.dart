import 'package:flutter/material.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/widgets/smooth_star_rating.dart';
import 'package:intl/intl.dart';

class Reviews extends StatelessWidget {
  final List reviews;
  Reviews({this.reviews});

  @override
  Widget build(BuildContext context) {
    return reviews != null
        ? ListView.builder(
            shrinkWrap: true,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reviews == null ? 0 : reviews.length,
            itemBuilder: (BuildContext context, int index) {
              var comment = reviews[index];
              var date = DateFormat.yMMMMd('en_US')
                  .format(DateTime.parse(comment['dateAdded']));
              return ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                    "${Constants.uploadUrl + comment['reviewer']['profile_pic_file_name']}",
                  ),
                ),
                title: Text(
                    "${comment['reviewer']['user_first_name']} ${comment['reviewer']['user_last_name']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SmoothStarRating(
                          starCount: 5,
                          color: Constants.ratingBG,
                          allowHalfRating: true,
                          rating: 5.0,
                          borderColor: Constants.ratingBG,
                          size: 12.0,
                        ),
                        SizedBox(width: 6.0),
                        Text(
                          "$date",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7.0),
                    Text(
                      "${comment['review']}",
                    ),
                  ],
                ),
              );
            },
          )
        : Center(
            child: Text(
              "No comment",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
