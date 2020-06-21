import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/job/provider/my_request_provider.dart';
import 'package:quickfix/modules/job/widget/my_request.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/pending_request.dart';

class MyRequests extends StatefulWidget {
  @override
  _MyRequestsState createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests>
    with AutomaticKeepAliveClientMixin<MyRequests> {
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
    super.initState();
    getMyRequest();
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
                    child: ListView.builder(
                      itemCount: requests == null ? 0 : requests.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MyRequestWidget(
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
