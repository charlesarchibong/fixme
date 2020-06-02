import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickfix/screens/details.dart';
import 'package:quickfix/screens/track_artisan.dart';

class MyRequestWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;

  MyRequestWidget({
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
          trailing: _myRequestAction(),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _myRequestAction() {
    return PopupMenuButton(
      onSelected: (value) {
        print(value);
        if (value == 4) {}
      },
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.eye,
                color: Colors.green,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text('View Details'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => TrackArtisan()));
            },
            child: Row(
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.map,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('Track Artisan'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
