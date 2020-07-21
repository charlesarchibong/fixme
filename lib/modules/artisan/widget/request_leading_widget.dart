import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickfix/modules/artisan/model/service_request.dart';

class RequestLeadingWidget extends StatelessWidget {
  final ServiceRequest serviceRequest;
  const RequestLeadingWidget({
    Key key,
    this.serviceRequest,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: serviceRequest.status == 'rejected'
          ? serviceRequest.status == 'pending' ? Colors.orange : Colors.red
          : Colors.green,
      child: FaIcon(
        serviceRequest.status == 'rejected'
            ? FontAwesomeIcons.windowClose
            : serviceRequest.status == 'pending'
                ? FontAwesomeIcons.ellipsisH
                : FontAwesomeIcons.check,
        color: Colors.white,
      ),
    );
  }
}
