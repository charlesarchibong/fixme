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
              'Request From: ',
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
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: this.subtitle,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
              TextSpan(
                text: ' \nDate: ${job.dateRequested}',
                style: TextStyle(
                  // color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextSpan(
                text: ' \nStatus $status',
                style: TextStyle(
                  // color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
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
                    final approvedBidProvider =
                        Provider.of<RequestArtisanService>(
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
                    final approvedBidProvider =
                        Provider.of<RequestArtisanService>(
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
              final approvedBidProvider = Provider.of<RequestArtisanService>(
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
      ],
    );
  }
}
