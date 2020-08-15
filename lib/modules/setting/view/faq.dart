import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/const.dart';
import '../../artisan/provider/artisan_provider.dart';

class Faq extends StatefulWidget {
  Faq({Key key}) : super(key: key);

  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ArtisanProvider>(
        builder: (context, artisanProvider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'FAQ',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Column(
              children: <Widget>[],
            ),
          ),
        ),
      );
    });
  }

  // Widget _help() {
  //   return ListTile(
  //     onTap: () {},
  //     leading: FaIcon(
  //       FontAwesomeIcons.questionCircle,
  //       color: Colors.grey,
  //     ),
  //     title: Text(
  //       "Help",
  //       style: TextStyle(
  //         fontSize: 17,
  //         fontWeight: FontWeight.w700,
  //       ),
  //     ),
  //     subtitle: Text(
  //       "FAQ, Contact us, Privacy policy",
  //       style: TextStyle(
  //         fontSize: 15,
  //         fontWeight: FontWeight.w700,
  //       ),
  //     ),
  //   );
  // }

  bool get wantKeepAlive => true;
}
