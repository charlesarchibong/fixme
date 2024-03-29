import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';

import '../../../models/failure.dart';
import '../../../util/const.dart';
import '../../../util/graph.dart';
import '../model/dashboard_model.dart';
import '../provider/dashboard_provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
  final PageController pageController;
  Dashboard({@required this.pageController});
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  static final List<String> chartDropdownItems = [
    'Last 7 days',
    'Last month',
    'Last year'
  ];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
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
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Consumer<DashBoardProvider>(
            builder: (context, dashboardProvider, child) {
          return FutureBuilder(
              future: dashboardProvider.getDashboardData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data.fold((Failure failure) {
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
                  }, (DashboardModel dashboardModel) {
                    return StaggeredGridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24.0,
                            right: 24.0,
                            top: 15.0,
                            bottom: 15.0,
                          ),
                          child: Text(
                            'Dashboard',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        _buildTile(
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Total Profile Views',
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                      Text(
                                        '${dashboardModel.profileViews}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 34.0),
                                      ),
                                    ],
                                  ),
                                  Material(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(24.0),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                          16.0,
                                        ),
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.white,
                                          size: 30.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        _buildTile(
                          Padding(
                            padding: const EdgeInsets.all(
                              24.0,
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Material(
                                    color: Colors.teal,
                                    shape: CircleBorder(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                        16.0,
                                      ),
                                      child: Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                  ),
                                  Text(
                                    'Ratings',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                  Text(
                                    '${dashboardModel.ratings}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        _buildTile(
                          Padding(
                            padding: const EdgeInsets.all(
                              24.0,
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Material(
                                    color: Colors.amber,
                                    shape: CircleBorder(),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                        16.0,
                                      ),
                                      child: Icon(
                                        Icons.rate_review,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                  ),
                                  Text(
                                    'Reviews',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24.0),
                                  ),
                                  Text(
                                    '${dashboardModel.reviews}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        _buildTile(
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Total Revenue',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        Text(
                                          'N${dashboardModel.totalRevenue}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 34.0),
                                        ),
                                      ],
                                    ),
                                    DropdownButton(
                                        isDense: true,
                                        value: actualDropdown,
                                        onChanged: (String value) {
                                          // setState(() {
                                          //     actualDropdown = value;
                                          //     actualChart =
                                          //         chartDropdownItems.indexOf(
                                          //             value); // Refresh the chart
                                          //   })
                                        },
                                        items: chartDropdownItems
                                            .map((String title) {
                                          return DropdownMenuItem(
                                            value: title,
                                            child: Text(
                                              title,
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.0),
                                            ),
                                          );
                                        }).toList())
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 4.0)),
                                Sparkline(
                                  data: charts[actualChart],
                                  lineWidth: 5.0,
                                  lineColor: Colors.greenAccent,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashboardProvider, child) {
                            return _buildTile(
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Wallet Balance',
                                            style: TextStyle(
                                                color: Colors.blueAccent),
                                          ),
                                          Text(
                                            'N${dashboardModel.accountBalance}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 34.0),
                                          ),
                                        ],
                                      ),
                                      Material(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                              16.0,
                                            ),
                                            child: Icon(
                                              Icons.account_balance_wallet,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                              onTap: () {
                                //widget.pageController.jumpToPage(4);
                              },
                            );
                          },
                        ),
                        Consumer<DashBoardProvider>(
                          builder: (context, dashboardProvider, child) {
                            return _buildTile(
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Requests',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                        Text(
                                          '${dashboardModel.serviceRequest}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 34.0),
                                        ),
                                      ],
                                    ),
                                    Material(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(24.0),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Icon(Icons.shopping_cart,
                                              color: Colors.white, size: 30.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //onTap: () =>//widget.pageController.jumpToPage(3),
                            );
                          },
                        ),
                        _buildTile(
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Completed Requests',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    Text(
                                      '${dashboardModel.completedJobs}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 34.0),
                                    ),
                                  ],
                                ),
                                Material(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Icon(Icons.check_circle,
                                          color: Colors.white, size: 30.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => null,
                        )
                      ],
                      staggeredTiles: [
                        StaggeredTile.extent(3, 60.0),
                        StaggeredTile.extent(2, 110.0),
                        StaggeredTile.extent(1, 180.0),
                        StaggeredTile.extent(1, 180.0),
                        StaggeredTile.extent(2, 220.0),
                        StaggeredTile.extent(2, 110.0),
                        StaggeredTile.extent(2, 110.0),
                        StaggeredTile.extent(2, 110.0),
                      ],
                    );
                  });
                } else {
                  return Center(
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              });
        }));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(
        // Do onTap() if it isn't null, otherwise do print()
        onTap: onTap != null
            ? () => onTap()
            : () {
                print('Not set yet');
              },
        child: child,
      ),
    );
  }
}
