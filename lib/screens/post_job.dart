import 'package:call_a_technician/models/job_category.dart';
import 'package:call_a_technician/providers/login_form_validation.dart';
import 'package:call_a_technician/providers/post_job_provider.dart';
import 'package:call_a_technician/util/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PostJob extends StatefulWidget {
  @override
  _PostJobState createState() => _PostJobState();
}

JobCategory jobCategory;
List<JobCategory> jobCategories = <JobCategory>[
  JobCategory(id: '1', title: 'Mechanical'),
  JobCategory(id: '2', title: 'Electrical')
];

class _PostJobState extends State<PostJob> {
  @override
  Widget build(BuildContext context) {
    final postJob = Provider.of<PostJobProvider>(context);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Constants.lightAccent,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              "Post Job",
              style: TextStyle(color: Colors.white),
            ),
            elevation: 0.0),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 20.0),
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Post a job in Call A Technician community and get technicians around you notified and bid your job offer and you choose your prefered technician',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  )),
              SizedBox(height: 20.0),
              Card(
                elevation: 3.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    textCapitalization: TextCapitalization.none,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      errorText:
                          postJob.title ? 'Job title can not be empty' : null,
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
                      hintText: "Job Title",
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      prefixIcon: Icon(
                        Icons.add_comment,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: 1,
                    autocorrect: true,
                    // controller: _usernameControl,
                  ),
                ),
              ),
              Card(
                elevation: 3.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      errorText: postJob.description
                          ? 'Job description can not be empty'
                          : null,
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
                      hintText: "Job Description",
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      prefixIcon: Icon(
                        Icons.description,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: null,
                    autocorrect: true,
                    // controller: _usernameControl,
                  ),
                ),
              ),
              Card(
                elevation: 3.0,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: DropdownButton<JobCategory>(
                      value: jobCategory,
                      hint: Text(
                        'Select Job Category',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: Icon(Icons.arrow_downward, color: Colors.black),
                      items: jobCategories.map((JobCategory value) {
                        return DropdownMenuItem<JobCategory>(
                          value: value,
                          child: Text(value.title),
                        );
                      }).toList(),
                      onChanged: (JobCategory newValue) {
                        setState(() {
                          jobCategory = newValue;
                        });
                        // print(jobCategory.id);
                      },
                    )),
              ),
              Card(
                elevation: 3.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      errorText:
                          postJob.price ? 'Job price can not be empty' : null,
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
                      hintText: "Job Price",
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      prefixIcon: Icon(
                        Icons.monetization_on,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: null,
                    autocorrect: true,
                    // controller: _usernameControl,
                  ),
                ),
              ),
              Card(
                elevation: 3.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      errorText: postJob.address
                          ? 'Job address can not be empty'
                          : null,
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
                      hintText: "Job Address location",
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: null,
                    autocorrect: true,
                    // controller: _usernameControl,
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              Container(
                height: 50.0,
                child: RaisedButton(
                  child: postJob.loading
                      ? Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(
                          "Add Job".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                  onPressed: () {
                    // _recoverUser();
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ));
  }
}
