import 'package:flutter/material.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/modules/artisan/model/service_request.dart';
import 'package:quickfix/util/const.dart';

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
        backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Service Request Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Column(
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/service_request.png',
                  width: 250,
                ),
              ),
              _serviceRequestDetails(),
              // SizedBox(height: 4.0),
              RaisedButton(
                  child: Text(
                    'Rate Service Provider',
                    style: TextStyle(
                      color: Colors.white,
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
                  }),
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
          _serviceRequestListTile(
            'Service Requested Contact',
            widget.serviceRequest.requestedMobile,
          ),
          _serviceRequestListTile(
            'Service Provider Contant',
            widget.serviceRequest.requestingMobile,
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
      ),
    );
  }
}
