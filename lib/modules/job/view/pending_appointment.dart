import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../models/failure.dart';
import '../model/job.dart';
import '../provider/pending_job_provider.dart';
import '../widget/appointment.dart';

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
    var bby = 'cakewf';
    print(bby);
    final pendingJobProvider =
        Provider.of<PendingJobProvider>(context, listen: false);
    final fetched = await pendingJobProvider.getPendingRequest();
    fetched.fold((Failure failure) {
      if (mounted) {
        setState(() {
          error = failure.message;
          isloading = false;
        });
      }
    }, (List<Job> jobs) {
      if (mounted) {
        setState(() {
          isloading = false;
          jobsAround = jobs;
          bby = 'Done';
        });
      }
      print(bby);
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
                  Consumer<PendingJobProvider>(
                    builder: (
                      BuildContext context,
                      PendingJobProvider pendingJobProvider,
                      Widget child,
                    ) {
                      return Expanded(
                        child: jobsAround.length > 0
                            ? RefreshIndicator(
                                onRefresh: () {
                                  return getPendingRequest();
                                },
                                child: ListView.builder(
                                  itemCount: pendingJobProvider
                                              .listOfJobs.length ==
                                          null
                                      ? 0
                                      : pendingJobProvider.listOfJobs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return PendingAppointments(
                                      job: pendingJobProvider.listOfJobs[index],
                                      title: pendingJobProvider
                                          .listOfJobs[index].jobTitle,
                                      subtitle:
                                          '${pendingJobProvider.listOfJobs[index].description} - N${double.parse(pendingJobProvider.listOfJobs[index].price.toString())}',
                                      status: pendingJobProvider
                                          .listOfJobs[index].status,
                                      index: index,
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
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
