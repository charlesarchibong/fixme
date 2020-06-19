import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/widgets/popup_button.dart';

class PendingAppointments extends StatelessWidget {
  final Job job;
  final String title;
  final String subtitle;
  final String status;

  PendingAppointments({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.status,
    @required this.job,
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
        ),
        onTap: () {
          FlushBarCustomHelper.showInfoFlushbar(
            context,
            'Message',
            'Click the three dot button beside to bid this job',
          );
        },
      ),
    );
  }
}
