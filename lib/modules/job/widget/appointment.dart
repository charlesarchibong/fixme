import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/job/view/job_details.dart';
import 'package:quickfix/providers/app_provider.dart';
import 'package:quickfix/util/const.dart';
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
      child: Card(
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
                width: 5.0,
              ),
              Text(
                this.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          subtitle: RichText(
            text: TextSpan(
              text: 'Description: ',
              style: TextStyle(
                color: Provider.of<AppProvider>(context).theme ==
                        Constants.lightTheme
                    ? Colors.black
                    : Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: this.subtitle,
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                TextSpan(
                  text: ' \nDate: ${job.datePosted}',
                  style: TextStyle(
                    // color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
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
      ),
    );
  }
}
