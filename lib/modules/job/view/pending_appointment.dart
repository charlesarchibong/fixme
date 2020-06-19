import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/job/provider/pending_job_provider.dart';
import 'package:quickfix/modules/job/widget/appointment.dart';

class PendingAppointment extends StatefulWidget {
  @override
  _PendingAppointmentState createState() => _PendingAppointmentState();
}

class _PendingAppointmentState extends State<PendingAppointment>
    with AutomaticKeepAliveClientMixin<PendingAppointment> {
  bool isloading = true;
  String error = '';
  List<Job> jobsAround = List();

  Future<void> getPendingRequest() async {
    // print('snjfna');
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
        jobsAround = jobs;
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
                    child: jobsAround.length > 0
                        ? RefreshIndicator(
                            onRefresh: () {
                              return getPendingRequest();
                            },
                            child: ListView.builder(
                              itemCount: jobsAround.length == null
                                  ? 0
                                  : jobsAround.length,
                              itemBuilder: (BuildContext context, int index) {
                                return PendingAppointments(
                                  job: jobsAround[index],
                                  title: jobsAround[index].jobTitle,
                                  subtitle:
                                      '${jobsAround[index].description} - N${double.parse(jobsAround[index].price.toString())}',
                                  status: jobsAround[index].status,
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              error,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
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
