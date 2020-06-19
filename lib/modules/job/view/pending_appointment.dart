import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/job/provider/pending_job_provider.dart';
import 'package:quickfix/modules/job/widget/appointment.dart';
import 'package:quickfix/util/pending_request.dart';

class PendingAppointment extends StatefulWidget {
  @override
  _PendingAppointmentState createState() => _PendingAppointmentState();
}

class _PendingAppointmentState extends State<PendingAppointment>
    with AutomaticKeepAliveClientMixin<PendingAppointment> {
  bool isloading = true;
  String error = '';

  getPendingRequest() async {
    final pendingJobProvider =
        Provider.of<PendingJobProvider>(context, listen: false);
    final fetched = await pendingJobProvider.getPendingRequest();
    fetched.fold((Failure failure) {
      setState(() {
        error = failure.message;
        isloading = false;
      });
    }, (List<Job> jobs) {
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  void initState() {
    getPendingRequest();
    super.initState();
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
                      "Jobs Around You",
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
                      "Jobs Around You",
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
