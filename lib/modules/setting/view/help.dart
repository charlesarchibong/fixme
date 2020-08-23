import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/const.dart';
import '../../artisan/provider/artisan_provider.dart';
import 'faq.dart';

class Help extends StatefulWidget {
  Help({Key key}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ArtisanProvider>(
        builder: (context, artisanProvider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'Help',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Column(
              children: <Widget>[
                _faq(),
                _contactUs(),
                _termandPP(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _faq() {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Faq(),
          ),
        );
      },
      leading: FaIcon(
        FontAwesomeIcons.questionCircle,
        color: Colors.grey,
      ),
      title: Text(
        "FAQ",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _contactUs() {
    return ListTile(
      onTap: () async {
        var url = "mailto:hi@fixme.ng?subject=Contact Fixme for problem";
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      leading: FaIcon(
        FontAwesomeIcons.mailBulk,
        color: Colors.grey,
      ),
      title: Text(
        "Contact us",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        "Questions? Need help?",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _termandPP() {
    return ListTile(
      onTap: () async {
        var url = "https://fixme.ng/privacy-policy";
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      leading: FaIcon(
        FontAwesomeIcons.book,
        color: Colors.grey,
      ),
      title: Text(
        "Terms and Privacy Policy",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
}
