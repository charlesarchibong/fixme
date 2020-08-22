import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/artisan/model/service_request.dart';
import 'package:quickfix/modules/artisan/provider/artisan_provider.dart';
import 'package:quickfix/modules/artisan/widget/request_leading_widget.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/providers/app_provider.dart';
import 'package:quickfix/services/firebase/users.dart';
import 'package:quickfix/util/const.dart';
import 'package:url_launcher/url_launcher.dart';

class MyServiceRequestWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final ServiceRequest job;
  final String datePosted;

  MyServiceRequestWidget({
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
        leading: RequestLeadingWidget(
          serviceRequest: job,
        ),
        title: Row(
          children: <Widget>[
            Text(
              'From: ',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            StreamBuilder<User>(
                stream: UsersService(
                  userPhone: this.job.requestingMobile,
                ).user,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data?.firstName} ${snapshot.data?.lastName}',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                })
          ],
        ),
        subtitle: RichText(
          text: TextSpan(
            text: 'Mobile: ',
            style: TextStyle(
              color: Provider.of<AppProvider>(context).theme ==
                      Constants.lightTheme
                  ? Colors.black
                  : Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '+234${this.job.requestingMobile}',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    var url = "tel:0${this.job.requestingMobile}";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
              ),
              TextSpan(
                text: ' \nDate: ${job.dateRequested}',
                style: TextStyle(
                  // color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              this.job.status == 'pending'
                  ? TextSpan(
                      text: ' \nPlease confirm availability',
                      style: TextStyle(
                        // color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  : TextSpan(),
            ],
          ),
        ),
        trailing: _myBidAction(),
        onTap: () {
          FlushBarCustomHelper.showErrorFlushbar(
            context,
            'Info',
            'Please click on the three dot beside to accept or decline availability',
          );
        },
      ),
    );
  }

  Widget _myBidAction() {
    return PopupMenuButton(
      onSelected: (value) {
        print(value);
        print(job.toMap().toString());
        print(job.toMap().toString());
        print(job.toMap().toString());
      },
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      itemBuilder: (context) => [
        job.status == 'accepted'
            ? PopupMenuItem(
                value: 9,
                child: InkWell(
                  onTap: () async {
                    FlushbarHelper.createLoading(
                      message: 'Requesting for payment, please wait!',
                      linearProgressIndicator: LinearProgressIndicator(),
                      duration: Duration(minutes: 1),
                      title: 'Loading...',
                    )..show(context);
                    final approvedBidProvider = Provider.of<ArtisanProvider>(
                      context,
                      listen: false,
                    );
                    final accepted =
                        await approvedBidProvider.requestForPayment(job);
                    Navigator.of(context).pop();
                    accepted.fold((Failure failure) {
                      FlushBarCustomHelper.showErrorFlushbar(
                        context,
                        'Error',
                        failure.message,
                      );
                    }, (bool accepted) {
                      FlushBarCustomHelper.showInfoFlushbar(
                        context,
                        'Success',
                        'you have successfully requested for payment on this job, Service owner will be contacted with your FIXME account details',
                      );
                    });
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
                      Text('Completed Service/Request Payment'),
                    ],
                  ),
                ),
              )
            : PopupMenuItem(
                value: 1,
                child: InkWell(
                  onTap: () async {
                    FlushbarHelper.createLoading(
                      message: 'Confirming availability, please wait!',
                      linearProgressIndicator: LinearProgressIndicator(),
                      duration: Duration(minutes: 1),
                      title: 'Loading...',
                    )..show(context);
                    final approvedBidProvider = Provider.of<ArtisanProvider>(
                      context,
                      listen: false,
                    );
                    final accepted = await approvedBidProvider.acceptRequest(
                      job,
                    );
                    Navigator.of(context).pop();
                    accepted.fold((Failure failure) {
                      FlushBarCustomHelper.showErrorFlushbar(
                        context,
                        'Error',
                        failure.message,
                      );
                    }, (bool accepted) {
                      FlushBarCustomHelper.showInfoFlushbar(
                        context,
                        'Success',
                        'you have successfully confirmed your availabilty for this job/project and work as been initial',
                      );
                    });
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
              FlushbarHelper.createLoading(
                message: 'Rejecting request, please wait!',
                linearProgressIndicator: LinearProgressIndicator(),
                duration: Duration(minutes: 1),
                title: 'Loading...',
              )..show(context);
              final approvedBidProvider = Provider.of<ArtisanProvider>(
                context,
                listen: false,
              );
              final accepted = await approvedBidProvider.rejectRequest(
                job,
              );
              Navigator.of(context).pop();
              accepted.fold((Failure failure) {
                FlushBarCustomHelper.showErrorFlushbar(
                  context,
                  'Error',
                  failure.message,
                );
              }, (bool accepted) {
                FlushBarCustomHelper.showInfoFlushbar(
                  context,
                  'Success',
                  'you have successfully declined your availabilty for this job/project',
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
        PopupMenuItem(
          value: 8,
          child: InkWell(
            onTap: () async {
              var url = "tel:0${this.job.requestingMobile}";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Row(
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.phone,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('Call User'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
