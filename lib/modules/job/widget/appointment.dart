import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/job/view/job_details.dart';
import 'package:quickfix/widgets/popup_button.dart';

class PendingAppointments extends StatelessWidget {
  final Job job;
  final String title;
  final String subtitle;
  final String status;
  final int index;

  PendingAppointments({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.status,
    @required this.job,
    @required this.index,
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
        title: Text(
          this.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(this.subtitle),
        trailing: CustomPopupButton(
          job: job,
          index: index,
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => JobDetails(
                isOwner: false,
                job: job,
                index: index,
              ),
            ),
          );
        },
      ),
    );
  }
}
