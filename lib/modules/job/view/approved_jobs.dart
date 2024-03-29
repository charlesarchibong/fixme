import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/project_bid.dart';
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'My Bids',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
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
                      }, (List<ProjectBid> list) {
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
                              ProjectBid projectBid =
                                  approvedBidProiver.approvedBids[index];
                              return ApprovedBidWidget(
                                title: projectBid.bidderMobile,
                                subtitle: projectBid.dateApproved,
                                status: projectBid.status,
                                job: projectBid,
                                datePosted: projectBid.dateApproved,
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

  bool get wantKeepAlive => true;
}
