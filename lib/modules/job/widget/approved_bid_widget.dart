import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/project_bid.dart';
import 'package:quickfix/modules/job/provider/approve_bid_provider.dart';
import 'package:quickfix/providers/app_provider.dart';
import 'package:quickfix/util/const.dart';

class ApprovedBidWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final ProjectBid job;
  final String datePosted;

  ApprovedBidWidget({
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
                fontSize: 19,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              this.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
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
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: this.subtitle,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
              TextSpan(
                text: ' \nDate: $datePosted',
                style: TextStyle(
                  // color: Theme.of(context).primaryColor,
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: ' \nStatus $status',
                style: TextStyle(
                  // color: Theme.of(context).primaryColor,
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        trailing: _myBidAction(),
        onTap: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (_) => JobDetails(
          //       isOwner: true,
          //       job: job,
          //     ),
          //   ),
          // );
          if (job.status == ProjectBid.ACCEPTED_BID) {
            FlushBarCustomHelper.showErrorFlushbar(
              context,
              'Info',
              'Please click on the three dot beside to accept or decline availability',
            );
          }
        },
      ),
    );
  }

  Widget _myBidAction() {
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
            onTap: () async {
              FlushbarHelper.createLoading(
                message: 'Confirming availability, please wait!',
                linearProgressIndicator: LinearProgressIndicator(),
                duration: Duration(minutes: 1),
                title: 'Loading...',
              );
              final approvedBidProvider = Provider.of<ApprovedBidProvider>(
                context,
                listen: false,
              );
              final confirmed = await approvedBidProvider.confirmAvailability(
                job,
              );
              Navigator.of(context).pop();
              confirmed.fold((Failure failure) {
                FlushBarCustomHelper.showErrorFlushbar(
                  context,
                  'Error',
                  failure.message,
                );
              }, (bool confirmed) {
                FlushBarCustomHelper.showErrorFlushbar(
                  context,
                  'Success',
                  'you have successfully confirmed your availabilty for this job/project and work as been initial',
                );
              });
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (_) => JobDetails(
              //       isOwner: true,
              //       job: job,
              //     ),
              //   ),
              // );
            },
            child: Row(
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.checkCircle,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('Confirmed Availability'),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: InkWell(
            onTap: () async {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (_) => TrackArtisan(),
              //   ),
              // );
              FlushbarHelper.createLoading(
                message: 'Declining availability, please wait!',
                linearProgressIndicator: LinearProgressIndicator(),
                duration: Duration(minutes: 1),
                title: 'Loading...',
              );
              final approvedBidProvider = Provider.of<ApprovedBidProvider>(
                context,
                listen: false,
              );
              final declined = await approvedBidProvider.declineAvailability(
                job,
              );
              Navigator.of(context).pop();
              declined.fold((Failure failure) {
                FlushBarCustomHelper.showErrorFlushbar(
                  context,
                  'Error',
                  failure.message,
                );
              }, (bool confirmed) {
                FlushBarCustomHelper.showErrorFlushbar(
                  context,
                  'Success',
                  'you have successfully declined your availabilty for this job/project.',
                );
              });
            },
            child: Row(
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.windowClose,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('Decline Offer'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
