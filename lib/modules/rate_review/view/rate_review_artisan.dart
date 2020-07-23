import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/modules/artisan/view/my_requested_service.dart';
import 'package:quickfix/widgets/smooth_star_rating.dart';

class RateReviewArtisan extends StatefulWidget {
  @override
  _RateReviewArtisanState createState() => _RateReviewArtisanState();
}

class _RateReviewArtisanState extends State<RateReviewArtisan> {
  double rating = 0.0;
  TextEditingController _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<PageViewModel> pages = [
      PageViewModel(
        // title: "Get Technicain",
        title: 'Rate Artisan',
        body: '',
        image: _ratingWidget(),
        decoration: PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).accentColor,
          ),
          bodyTextStyle: TextStyle(fontSize: 15.0),
//          dotsDecorator: DotsDecorator(
//            activeColor: Theme.of(context).accentColor,
//            activeSize: Size.fromRadius(8),
//          ),
          pageColor: Theme.of(context).primaryColor,
        ),
      ),
      PageViewModel(
        title: "Write A Review for Artisan",
        body: "",
        image: _reviewWidget(),
        decoration: PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).accentColor,
          ),
          bodyTextStyle: TextStyle(fontSize: 15.0),
          boxDecoration: BoxDecoration(),
          pageColor: Theme.of(context).primaryColor,
        ),
      ),
    ];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text(
            'Rate and Review Artisan',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: IntroductionScreen(
            pages: pages,
            dotsDecorator: DotsDecorator(
              activeColor: Theme.of(context).accentColor,
              activeSize: Size.fromRadius(8),
            ),
            onDone: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MyRequestedService();
                  },
                ),
              );
            },
            showSkipButton: false,
            next: Text(
              "Next",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).accentColor,
              ),
            ),
            done: Text(
              "Done",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewWidget() {
    return Column(
      children: <Widget>[
        Card(
          elevation: 3.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Form(
              key: _formKey,
              child: TextFormField(
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.multiline,
                validator: (value) =>
                    value.isEmpty ? 'Review can not be empty' : null,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Enter a review",
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                  prefixIcon: Icon(
                    Icons.mode_edit,
                    color: Colors.grey,
                  ),
                ),
                maxLines: null,
                autocorrect: true,
                controller: _reviewController,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        RaisedButton(
          child: Text(
            "Submit",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: Theme.of(context).accentColor,
          onPressed: () async {
            FlushBarCustomHelper.showInfoFlushbar(
              context,
              'Loading',
              'Reviewing',
            );
          },
        ),
      ],
    );
  }

  Widget _ratingWidget() {
    return Column(
      children: <Widget>[
        SmoothStarRating(
          onRatingChanged: (value) {
            setState(() {
              rating = value;
            });
          },
          borderColor: Theme.of(context).accentColor,
          color: Theme.of(context).accentColor,
          rating: rating,
          size: 50,
          starCount: 5,
          spacing: 10,
          allowHalfRating: false,
        ),
        SizedBox(
          height: 10,
        ),
        RaisedButton(
          child: Text(
            "Submit",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: Theme.of(context).accentColor,
          onPressed: () async {
            FlushBarCustomHelper.showInfoFlushbar(
              context,
              'Loading',
              'Requesting',
            );
          },
        ),
      ],
    );
  }
}
