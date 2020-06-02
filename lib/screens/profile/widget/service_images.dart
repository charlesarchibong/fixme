import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/screens/profile/provider/profile_provider.dart';
import 'package:quickfix/util/const.dart';

class ServicesImages extends StatefulWidget {
  @override
  _ServicesImagesState createState() => _ServicesImagesState();
}

class _ServicesImagesState extends State<ServicesImages> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) => GridView.builder(
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2),
        ),
        itemCount:
            profileProvider.images == null ? 0 : profileProvider.images.length,
        itemBuilder: (BuildContext context, int index) {
          String image =
              Constants.uploadUrl + profileProvider.images[index].imageFileName;
          return FutureBuilder(
            future: profileProvider.getServiceImagesFromServer(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 500,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(),
                          child: Image.network(
                            image,
                            width: 500,
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            profileProvider.removeImage(index);
                          },
                          child: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.white,
                          ),
                          elevation: 5,
                          color: Colors.red,
                        ),
                      ],
                    )
                  : PlayStoreShimmer();
            },
          );
        },
      ),
    );
  }
}
