import 'package:flutter/material.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/util/const.dart';

class JobDetails extends StatefulWidget {
  final Job job;
  final bool isOwner;

  JobDetails({
    Key key,
    @required this.job,
    @required this.isOwner,
  }) : super(
          key: key,
        );

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Job Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget jobDetails() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "Job Details".toUpperCase(),
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        jobListTile(
          'Job Title',
          widget.job.jobTitle,
        ),
        jobListTile(
          'Job Description',
          widget.job.description,
        ),
        jobListTile(
          'Job Budget',
          widget.job.price.toString(),
        ),
        jobListTile(
          'Job Status',
          widget.job.status,
        ),
        // jobListTile('Job Status', widget.job.,),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget jobBidders() {
    return Container();
  }

  Widget jobListTile(String title, String subTitle) {
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

  Widget jobBiddersListTile() {}
}
