import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/provider/approve_bid_provider.dart';
import 'package:quickfix/modules/job/widget/approved_bid_widget.dart';
import 'package:quickfix/util/const.dart';

class ApprovedBid extends StatefulWidget {
  ApprovedBid({Key key}) : super(key: key);

  @override
  _ApprovedBidState createState() => _ApprovedBidState();
}

class _ApprovedBidState extends State<ApprovedBid> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Expanded(
              child: Consumer<ApprovedBidProvider>(
                  builder: (context, approvedBidProiver, child) {
                return FutureBuilder(
                  future: approvedBidProiver.getApprovedBids(),
                  builder: (BuildContext context, AsyncSnapshot approvedbids) {
                    if (approvedbids.connectionState == ConnectionState.done) {
                      return approvedbids.data.fold((Failure failure) {
                        return Center(
                          child: Text(
                            failure.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }, (Map jobs) {
                        return RefreshIndicator(
                          onRefresh: () {
                            approvedBidProiver.getApprovedBids();
                            return Future.value();
                          },
                          child: ListView.builder(
                            itemCount:
                                approvedBidProiver.approvedBids.length == null
                                    ? 0
                                    : approvedBidProiver.approvedBids.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ApprovedBidWidget(
                                  // title: myJobs[index].jobTitle,
                                  // subtitle: myJobs[index].description,
                                  // status: myJobs[index].status,
                                  // job: myJobs[index],
                                  // datePosted: myJobs[index].datePosted,
                                  );
                            },
                          ),
                        );
                      });
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
