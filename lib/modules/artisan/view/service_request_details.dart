import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/flush_bar.dart';
import '../../../util/const.dart';
import '../../rate_review/view/rate_review_artisan.dart';
import '../model/service_request.dart';

class ServiceRequestDetails extends StatefulWidget {
  final ServiceRequest serviceRequest;

  ServiceRequestDetails({
    Key key,
    @required this.serviceRequest,
  }) : super(
          key: key,
        );

  @override
  _ServiceRequestDetailsState createState() => _ServiceRequestDetailsState();
}

class _ServiceRequestDetailsState extends State<ServiceRequestDetails> {
  String error = '';
  bool loading = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Service Request Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            10.0,
            0,
            10.0,
            0,
          ),
          child: Column(
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/service_request.png',
                  width: 250,
                ),
              ),
              _serviceRequestDetails(),
              RaisedButton(
                child: Text(
                  'Call Artisan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                color: Color.fromRGBO(153, 0, 153, 1),
                onPressed: () {
                  FlushBarCustomHelper.showInfoFlushbarWithActionNot(
                    context,
                    'Information',
                    'Do you want to call this user?',
                    'Yes',
                    () async {
                      var url = "tel:0${widget.serviceRequest.requestedMobile}";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                child: Text(
                  'Rate Service Provider',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                color: Color.fromRGBO(153, 0, 153, 1),
                onPressed: () {
                  if (widget.serviceRequest.status != 'completed') {
                    FlushBarCustomHelper.showErrorFlushbar(
                      context,
                      'Error',
                      'You can not rate/review service provider until this request is completed',
                    );
                    return;
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RateReviewArtisan(
                        artisanPhone: widget.serviceRequest.requestedMobile,
                        serviceId: widget.serviceRequest.serviceId,
                        jobId: null,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceRequestDetails() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // _serviceRequestListTile(
          //   'Service Requested Contact',
          //   '+234${widget.serviceRequest.requestingMobile}',
          // ),
          _serviceRequestListTile(
            'Service Provider Contact',
            '+234${widget.serviceRequest.requestedMobile}',
          ),
          _serviceRequestListTile(
            'Service Status',
            '${widget.serviceRequest.status}',
          ),
          _serviceRequestListTile(
            'Date Requested',
            widget.serviceRequest.dateRequested,
          ),
          // _serviceRequestListTile('Job Status', widget.job.,),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _serviceRequestListTile(String title, String subTitle) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subTitle,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}
