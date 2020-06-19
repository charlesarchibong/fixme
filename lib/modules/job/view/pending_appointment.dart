import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:quickfix/modules/job/widget/appointment.dart';
import 'package:quickfix/util/pending_request.dart';

class PendingAppointment extends StatefulWidget {
  @override
  _PendingAppointmentState createState() => _PendingAppointmentState();
}

class _PendingAppointmentState extends State<PendingAppointment>
    with AutomaticKeepAliveClientMixin<PendingAppointment> {
  bool isloading = true;
  startTimeout() {
    return Timer(
      Duration(
        seconds: 5,
      ),
      setNotLoadin,
    );
  }

  setNotLoadin() {
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: isloading
            ? Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      "Request From User(s)",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTileShimmer(),
                  ListTileShimmer(),
                  ListTileShimmer(),
                  ListTileShimmer(),
                ],
              )
            : Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      "Request(s) From User(s)",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: requests == null ? 0 : requests.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PendingAppointments(
                          title: requests[index]['title'],
                          subtitle: requests[index]['subtitle'],
                          status: requests[index]['status'],
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
