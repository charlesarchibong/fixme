import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_provider.dart';
import '../../../util/const.dart';
import '../model/service_request.dart';
import '../view/service_request_details.dart';
import 'request_leading_widget.dart';

class MyRequestedServiceWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final ServiceRequest job;
  final String datePosted;

  MyRequestedServiceWidget({
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
        trailing: _myRequestedServiceAction(),
        title: Row(
          children: <Widget>[
            // Text(
            //   'Request From: ',
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            SizedBox(
              width: 5.0,
            ),
            // Text(
            //   this.title,
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //   ),
            // )
          ],
        ),
        subtitle: RichText(
          text: TextSpan(
            text: 'Description: ',
            style: GoogleFonts.solway(
              textStyle: TextStyle(
                color: Provider.of<AppProvider>(context).theme ==
                        Constants.lightTheme
                    ? Colors.black
                    : Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <TextSpan>[
              TextSpan(
                text: this.subtitle,
                style: GoogleFonts.solway(
                  textStyle: TextStyle(
                    color: Provider.of<AppProvider>(context).theme ==
                            Constants.lightTheme
                        ? Colors.black
                        : Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
              TextSpan(
                text: ' \nDate: ${job.dateRequested}',
                style: GoogleFonts.solway(
                  textStyle: TextStyle(
                    color: Provider.of<AppProvider>(context).theme ==
                            Constants.lightTheme
                        ? Colors.black
                        : Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextSpan(
                text: ' \nStatus: $status',
                style: TextStyle(
                  // color: Theme.of(context).primaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        // trailing: _myBidAction(),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ServiceRequestDetails(
                serviceRequest: job,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _myRequestedServiceAction() {
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ServiceRequestDetails(
                    serviceRequest: job,
                  ),
                ),
              );
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
                Text('View Details'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
