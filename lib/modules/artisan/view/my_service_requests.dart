import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/artisan/model/service_request.dart';
import 'package:quickfix/modules/artisan/provider/artisan_provider.dart';
import 'package:quickfix/modules/artisan/widget/my_service_request.dart';
import 'package:quickfix/util/const.dart';

class MyServiceRequests extends StatefulWidget {
  MyServiceRequests({Key key}) : super(key: key);

  @override
  _MyServiceRequestsState createState() => _MyServiceRequestsState();
}

class _MyServiceRequestsState extends State<MyServiceRequests> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.lightAccent,
//          automaticallyImplyLeading: false,
//          centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'My Service Requests',
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
              child: Consumer<RequestArtisanService>(
                  builder: (context, requestArtisanService, child) {
                return FutureBuilder(
                  future: requestArtisanService.getMyRequestedService(),
                  builder: (BuildContext context, AsyncSnapshot myService) {
                    if (myService.hasData) {
                      return myService.data.fold((Failure failure) {
                        return Center(
                          child: Text(
                            '${failure.message} asf',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }, (List<ServiceRequest> jobs) {
                        return RefreshIndicator(
                          onRefresh: () {
                            print('Fuck you');
                            requestArtisanService.getMyRequestedService();
                            return Future.value();
                          },
                          child: ListView.builder(
                            itemCount: jobs.length == null ? 0 : jobs.length,
                            itemBuilder: (BuildContext context, int index) {
                              ServiceRequest serviceRequest = jobs[index];
                              print('nnn');
                              return MyServiceRequestWidget(
                                title: serviceRequest.requestingMobile,
                                subtitle: 'Please confirm availability',
                                status: serviceRequest.status,
                                job: serviceRequest,
                                datePosted: serviceRequest.dateRequested,
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
