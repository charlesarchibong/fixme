import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/job/provider/my_request_provider.dart';
import 'package:quickfix/modules/job/widget/my_request.dart';
import 'package:quickfix/util/const.dart';

class MyRequests extends StatefulWidget {
  @override
  _MyRequestsState createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests>
    with AutomaticKeepAliveClientMixin<MyRequests>, WidgetsBindingObserver {
  bool isloading = true;
  String error = '';
  List<Job> myJobs = List();

  Future<void> getMyRequest() async {
    // print('snjfna');
    final pendingJobProvider =
        Provider.of<MyRequestProvider>(context, listen: false);
    final fetched = await pendingJobProvider.getMyRequests();
    fetched.fold((Failure failure) {
      setState(() {
        error = failure.message;
        isloading = false;
      });
    }, (List<Job> jobs) {
      setState(() {
        isloading = false;
        myJobs = jobs;
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    getMyRequest();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setStatusBar();
  }

  void setStatusBar() async {
    setState(() {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
      FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(153, 0, 153, 1.0));
      FlutterStatusbarcolor.setNavigationBarColor(
        Color.fromRGBO(153, 0, 153, 1.0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'My Jobs',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: isloading
            ? Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  ListTileShimmer(),
                  ListTileShimmer(),
                  ListTileShimmer(),
                  ListTileShimmer(),
                ],
              )
            : Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Expanded(
                    child: myJobs.length > 0
                        ? RefreshIndicator(
                            onRefresh: () => getMyRequest(),
                            child: ListView.builder(
                              itemCount: myJobs == null ? 0 : myJobs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MyRequestWidget(
                                  title: myJobs[index].jobTitle,
                                  subtitle: myJobs[index].description,
                                  status: myJobs[index].status,
                                  job: myJobs[index],
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
