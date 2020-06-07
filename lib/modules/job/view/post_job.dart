import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quickfix/helpers/flush_bar.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/job_category.dart';
import 'package:quickfix/modules/job/provider/post_job_provider.dart';

class PostJob extends StatefulWidget {
  @override
  _PostJobState createState() => _PostJobState();
}

JobCategory jobCategory;

List<JobCategory> jobCategories = List();

String error = '';

class _PostJobState extends State<PostJob> {
  TextEditingController _jobTitleController = TextEditingController();
  TextEditingController _jobDescriptionController = TextEditingController();
  TextEditingController _jobPriceController = TextEditingController();
  TextEditingController _jobAddressController = TextEditingController();

  Future getJobCategory() async {
    final postJob = Provider.of<PostJobProvider>(context, listen: false);
    final fetched = await postJob.getJobCategories();
    fetched.fold((Failure failure) {
      setState(() {
        error = 'An error occured, please try again!';
      });
      FlushBarCustomHelper.showErrorFlushbar(
          context, 'Error', 'An error occured, please try again!');
    }, (List<JobCategory> list) {
      setState(() {
        jobCategories = list;
      });
    });
  }

  @override
  void initState() {
    error = '';
    getJobCategory();
    jobCategory = null;
    super.initState();
  }

  @override
  void dispose() {
    jobCategory = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postJob = Provider.of<PostJobProvider>(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final _formKey = GlobalKey<FormState>();
    bool loading = false;
    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
        child: jobCategories.isEmpty
            ? Center(
                child: error.isEmpty
                    ? CircularProgressIndicator()
                    : Text(
                        error,
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Center(
                      child: Text(
                        "Post Job",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
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
                        child: TextFormField(
                          textCapitalization: TextCapitalization.none,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            errorText: postJob.title
                                ? 'Job title can not be empty'
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
                            hintText: "Job Title",
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                            prefixIcon: Icon(
                              Icons.add_comment,
                              color: Colors.grey,
                            ),
                          ),
                          maxLines: 1,
                          autocorrect: true,
                          controller: _jobTitleController,
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
                        child: TextFormField(
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
                              color: Colors.grey,
                            ),
                            prefixIcon: Icon(
                              Icons.description,
                              color: Colors.grey,
                            ),
                          ),
                          maxLines: null,
                          autocorrect: true,
                          controller: _jobDescriptionController,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 3.0,
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                color: Colors.grey,
                              ),
                            ),
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: Icon(
                              Icons.arrow_downward,
                              color: Colors.grey,
                            ),
                            items: jobCategories.map((JobCategory value) {
                              return DropdownMenuItem<JobCategory>(
                                value: value,
                                child: Text(value.service),
                              );
                            }).toList(),
                            onChanged: (JobCategory newValue) {
                              setState(() {
                                jobCategory = newValue;
                              });
                              print(jobCategory.service);
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
                        child: TextFormField(
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
                            errorText: postJob.price
                                ? 'Job price can not be empty'
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
                            hintText: "Job Price",
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                            prefixIcon: Icon(
                              Icons.monetization_on,
                              color: Colors.grey,
                            ),
                          ),
                          maxLines: null,
                          autocorrect: true,
                          controller: _jobPriceController,
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
                        child: TextFormField(
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.multiline,
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
                              color: Colors.grey,
                            ),
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                          ),
                          maxLines: null,
                          autocorrect: true,
                          controller: _jobAddressController,
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Container(
                      height: 50.0,
                      child: RaisedButton(
                        child: loading
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
              ),
      ),
    );
  }
}
