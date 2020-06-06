import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';

import 'package:quickfix/modules/profile/model/service_image.dart';
import 'package:quickfix/modules/profile/provider/profile_provider.dart';
import 'package:quickfix/util/const.dart';

class ServicesImages extends StatefulWidget {
  final List<ServiceImage> listImages;
  const ServicesImages({
    Key key,
    this.listImages,
  }) : super(key: key);

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
        itemCount: widget.listImages == null ? 0 : widget.listImages,
        itemBuilder: (BuildContext context, int index) {
          String image =
              Constants.uploadUrl + widget.listImages[index].imageFileName;

          return widget.listImages.isNotEmpty
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
      ),
    );
  }
}
