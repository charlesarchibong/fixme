import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickfix/screens/details.dart';
import 'package:quickfix/widgets/popup_button.dart';

class PendingAppointments extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;

  PendingAppointments({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.status,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ProductDetails();
              },
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange,
            child: FaIcon(
              FontAwesomeIcons.ellipsisH,
              color: Colors.white,
            ),
          ),
          title: Text(
            this.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(this.subtitle),
          trailing: CustomPopupButton(),
          onTap: () {},
        ),
      ),
    );
  }
}
