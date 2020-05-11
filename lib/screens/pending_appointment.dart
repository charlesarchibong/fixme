import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:quickfix/util/pending_request.dart';
import 'package:quickfix/widgets/appointment.dart';

class PendingAppointment extends StatefulWidget {
  @override
  _PendingAppointmentState createState() => _PendingAppointmentState();
}

class _PendingAppointmentState extends State<PendingAppointment>
    with AutomaticKeepAliveClientMixin<PendingAppointment> {
  bool isloading = true;
  startTimeout() {
    return Timer(Duration(seconds: 5), setNotLoadin);
  }

  setNotLoadin() {
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
                  ListTileShimmer(),
                  ListTileShimmer(),
                  ListTileShimmer(),
                  ListTileShimmer(),
                ],
              )
            : ListView.builder(
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
