import 'package:quickfix/util/comments.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/widgets/smooth_star_rating.dart';
import 'package:flutter/material.dart';

class Reviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      itemCount: comments == null ? 0 : comments.length,
      itemBuilder: (BuildContext context, int index) {
        Map comment = comments[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage(
              "${comment['img']}",
            ),
          ),
          title: Text("${comment['name']}"),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SmoothStarRating(
                    starCount: 5,
                    color: Constants.ratingBG,
                    allowHalfRating: true,
                    rating: 5.0,
                    size: 12.0,
                  ),
                  SizedBox(width: 6.0),
                  Text(
                    "February 14, 2020",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7.0),
              Text(
                "${comment["comment"]}",
              ),
            ],
          ),
        );
      },
    );
  }
}
