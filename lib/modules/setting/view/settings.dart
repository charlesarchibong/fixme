import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../../providers/app_provider.dart';
import '../../../util/const.dart';
import '../../artisan/provider/artisan_provider.dart';
import 'help.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
            'Settings',
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
                _darkTheme(),
                _help(),
                Divider(
                  color: Colors.grey,
                ),
                _inviteAFriend(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _darkTheme() {
    return ListTile(
      leading: FaIcon(
        FontAwesomeIcons.adjust,
        color: Colors.grey,
      ),
      title: Text(
        "Application Theme",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        Provider.of<AppProvider>(context).theme == Constants.lightTheme
            ? "Light"
            : "Dark",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Switch(
        value: Provider.of<AppProvider>(context).theme == Constants.lightTheme
            ? false
            : true,
        onChanged: (v) async {
          if (v) {
            Provider.of<AppProvider>(context, listen: false).setTheme(
              Constants.darkTheme,
              "dark",
            );
          } else {
            Provider.of<AppProvider>(context, listen: false).setTheme(
              Constants.lightTheme,
              "light",
            );
          }
        },
        activeColor: Theme.of(context).accentColor,
      ),
    );
  }

  Widget _help() {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Help(),
          ),
        );
      },
      leading: FaIcon(
        FontAwesomeIcons.questionCircle,
        color: Colors.grey,
      ),
      title: Text(
        "Help",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        "FAQ, Contact us, Privacy policy",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _inviteAFriend() {
    return ListTile(
      onTap: () {
        Share.share(
          'Fixme makes it easier for you as a service provider or business owner to get hired faster  and more frequently through our platform. Download free at https://fixme.ng/',
          subject: 'Download ${Constants.appName} for Android and iOS',
        );
      },
      leading: FaIcon(
        FontAwesomeIcons.userFriends,
        color: Colors.grey,
      ),
      title: Text(
        "Invite a friend",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
}
