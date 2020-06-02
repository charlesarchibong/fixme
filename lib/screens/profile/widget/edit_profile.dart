import 'package:flutter/material.dart';

class EditProfilePopUp extends StatefulWidget {
  @override
  _EditProfilePopUpState createState() => _EditProfilePopUpState();
}

class _EditProfilePopUpState extends State<EditProfilePopUp> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

_showProfilePopUp(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Image.asset(
                      'assets/icons/pdf.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          '25 Reasons your marketing is not working',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'By Jim Rohn',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Slider(
                    value: 2.5,
                    onChanged: (val) {},
                    max: 5.0,
                    min: 0.0,
                  ),
                  Text(
                    '2:50 - 5:00',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.skip_previous,
                        color: Colors.blue,
                        size: 40,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.play_circle_outline,
                        color: Colors.blue,
                        size: 60,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.skip_next,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
}
