import 'package:flutter/material.dart';
import 'package:quickfix/modules/job/model/job.dart';

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
    return Container();
  }
}
