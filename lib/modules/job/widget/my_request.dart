import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickfix/modules/artisan/view/track_artisan.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/job/view/job_details.dart';

class MyRequestWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Job job;
  final String datePosted;

  MyRequestWidget({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.job,
    @required this.status,
    @required this.datePosted,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: FaIcon(
            FontAwesomeIcons.ellipsisH,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: <Widget>[
            Text(
              'Title:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              this.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(this.subtitle),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Date Posted:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(this.datePosted),
              ],
            ),
          ],
        ),
        trailing: _myRequestAction(),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => JobDetails(
                isOwner: true,
                job: job,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _myRequestAction() {
    return PopupMenuButton(
      onSelected: (value) {
        print(value);
      },
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => JobDetails(
                    isOwner: true,
                    job: job,
                  ),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.eye,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('View Job Details'),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TrackArtisan(),
                ),
              );
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
