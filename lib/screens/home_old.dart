import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:quickfix/screens/dishes.dart';
import 'package:quickfix/util/categories.dart';
import 'package:quickfix/util/foods.dart';
import 'package:quickfix/widgets/grid_product.dart';
import 'package:quickfix/widgets/home_category.dart';
import 'package:quickfix/widgets/slider_item.dart';

class HomeW extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeW>
    with AutomaticKeepAliveClientMixin<HomeW> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Popular Artisans",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FlatButton(
                  child: Text(
                    "View More",
                    style: TextStyle(
                      fontSize: 12,
//                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Aritsans();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 10.0),

            //Slider Here

            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 1.0,
                height: MediaQuery.of(context).size.height / 2.4,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: map<Widget>(
                technicians,
                (index, i) {
                  Map food = technicians[index];
                  return SliderItem(
                    img: food['img'],
                    isFav: true,
                    name: food['name'],
                    rating: 5.0,
                    raters: 23,
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 20.0),

            Text(
              "Jobs Categories",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              height: 65.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categories == null ? 0 : categories.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = categories[index];
                  return HomeCategory(
                    icon: cat['icon'],
                    title: cat['name'],
                    items: cat['items'].toString(),
                    isHome: true,
                  );
                },
              ),
            ),

            SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Service Providers",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FlatButton(
                  child: Text(
                    "View More",
                    style: TextStyle(
                      fontSize: 12,
//                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10.0),

            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.25),
              ),
              itemCount: technicians == null ? 0 : technicians.length,
              itemBuilder: (BuildContext context, int index) {
//                Food food = Food.fromJson(foods[index]);
                Map technician = technicians[index];
//                print(foods);
//                print(foods.length);
                return GridProduct(
                  img: technician['img'],
                  isFav: false,
                  name: technician['name'],
                  rating: 5.0,
                  raters: 23,
                );
              },
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
