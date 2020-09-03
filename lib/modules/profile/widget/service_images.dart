import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../util/const.dart';
import '../model/service_image.dart';
import '../provider/profile_provider.dart';

class ServicesImages extends StatefulWidget {
  final List<ServiceImage> listImages;
  ServicesImages({@required this.listImages});
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
            widget.listImages.length == null ? 0 : widget.listImages.length,
        itemBuilder: (BuildContext context, int index) {
          String image =
              Constants.uploadUrl + widget.listImages[index].imageFileName;

          return widget.listImages.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 500,
                      height: 100,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(),
                      child: Image(
                        image: NetworkImage(image),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        profileProvider.removeImage(
                          widget.listImages[index].imageFileName,
                        );
                      },
                      child: Icon(
                        Icons.remove,
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
