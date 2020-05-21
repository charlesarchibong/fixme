import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/providers/profile_provider.dart';

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
              (MediaQuery.of(context).size.height / 0.9),
        ),
        itemCount:
            profileProvider.images == null ? 0 : profileProvider.images.length,
        itemBuilder: (BuildContext context, int index) {
          String image = profileProvider.images[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 500,
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(),
                child: Image.network(
                  image,
                  width: 250,
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
          );
        },
      ),
    );
  }
}
