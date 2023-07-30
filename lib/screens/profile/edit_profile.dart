import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/providers/user.dart';
import 'package:ppl/services/image_upload.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/utils/constants.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:gender_selection/gender_selection.dart';

ProgressDialog pr;

class EditProfileScreen extends StatefulWidget {
  final Map userData;
  EditProfileScreen({Key key, @required this.userData}) : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File _profileImage;
  File _coverImage;
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  final lnameFocus = FocusNode();
  final emailFocus = FocusNode();
  final mobileFocus = FocusNode();
  String _gender;
  String _fname;
  String _lname;
  String _dob;
  String _email;
  String _countryCode;
  String _mobile;
  bool _autoValidate = false;
  final format = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
    print(widget.userData['user']);
  }

  updateProfileImage() async {
    ImageUpload imageUpload = ImageUpload();
    _profileImage = await imageUpload.uploadImage();
    setState(() {});
  }

  updateCoverImage() async {
    ImageUpload imageUpload = ImageUpload();
    _coverImage = await imageUpload.uploadImage();
    setState(() {});
  }

  void doValidate() {
    if (_profileFormKey.currentState.validate()) {
      _profileFormKey.currentState.save();
      doProfileUpdate();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void doProfileUpdate() {
    pr.show();
    Map body = {
      "first_name": _fname,
      "last_name": _lname,
      "email": _email,
      "country_code": _countryCode ?? widget.userData['user']['country_code'],
      "mobile": _mobile,
      "dob": _dob == null
          ? ""
          : _dob == 'null'
              ? ""
              : _dob,
      "gender": _gender == null && widget.userData['user']['gender'] == null
          ? ""
          : _gender != null
              ? _gender
              : widget.userData['user']['gender'],
    };
    print(body);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var user = Provider.of<UserModel>(context, listen: false);
      String token = user.userData['auth']['_token'];
      WebService api = WebService();
      final response =
          api.doUpdateProfile(token, body, _profileImage, _coverImage);
      response.then((value) {
        if (pr.isShowing()) {
          pr.hide();
        }
        var decodedData = jsonDecode(value.body);
        print(decodedData);
        final int statusCode = decodedData['serverResponse']['code'];
        final String message = decodedData['serverResponse']['message'];
        if (statusCode == 400) {
          this._showDialogError(message);
        } else if (statusCode == 401) {
          this._showDialogError(message);
          user.doRemoveUser();
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          Map userData = user.userData;
          userData['auth']['user'] = decodedData['result']['user'];
          user.doUpdateUser(json.encode(userData));
          this._showDialogSuccess(message);
        }
      }).catchError((onError) {
        if (pr.isShowing()) {
          pr.hide();
        }
        this._showDialogError(onError);
      });
    });
  }

  void _showDialogSuccess(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(AppTranslations.of(context).text('success')),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(AppTranslations.of(context).text('ok')),
              onPressed: () {
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogError(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(AppTranslations.of(context).text('error')),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(AppTranslations.of(context).text('close')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 55.0),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.5,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: colors,
              ),
            ),
          ),
          centerTitle: false,
          title: Container(
            child: Text(
              AppTranslations.of(context).text('edit_profile'),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'CalibriBold',
                fontSize: 16.0,
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              splashColor: Colors.white,
              icon: Icon(Icons.check),
              onPressed: () {
                this.doValidate();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: screenSize.height / 3.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _coverImage == null
                              ? NetworkImage(
                                  widget.userData['user']['cover_picture'],
                                )
                              : FileImage(_coverImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 20.0,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.blueAccent.withOpacity(0.5),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15.0),
                        child: InkWell(
                          child: Text(
                            AppTranslations.of(context).text('tap_to_change'),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'CalibriRegular',
                              fontSize: 12.0,
                            ),
                          ),
                          onTap: () => updateCoverImage(),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: screenSize.height / 25.0),
                    Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: _profileImage == null
                                    ? NetworkImage(
                                        widget.userData['user']
                                            ['profile_picture'],
                                      )
                                    : FileImage(_profileImage),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(80.0),
                              border: Border.all(
                                color: Colors.blueAccent,
                                width: 5.0,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            left: 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.blue,
                                size: 26.0,
                              ),
                              onPressed: () => updateProfileImage(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Form(
              key: _profileFormKey,
              autovalidate: _autoValidate,
              child: profileFormUI(),
            ),
            // ListView(
            //   shrinkWrap: true,
            //   physics: ScrollPhysics(),
            //   padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            //   children: <Widget>[
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         Text(
            //           'Name',
            //           style: TextStyle(
            //             fontFamily: 'CalibriRegular',
            //             fontSize: 14.0,
            //           ),
            //         ),
            //         InkWell(
            //           onTap: () {},
            //           child: Row(
            //             children: <Widget>[
            //               Text(
            //                 'Set Now',
            //                 style: TextStyle(
            //                   fontFamily: 'CalibriRegular',
            //                   fontSize: 14.0,
            //                   color: Colors.blue,
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: 5.0,
            //               ),
            //               Icon(
            //                 Icons.arrow_forward_ios,
            //                 size: 16.0,
            //                 color: Colors.grey,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //     Divider(
            //       height: 40.0,
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         Text(
            //           'Gender',
            //           style: TextStyle(
            //             fontFamily: 'CalibriRegular',
            //             fontSize: 14.0,
            //           ),
            //         ),
            //         InkWell(
            //           onTap: () {},
            //           child: Row(
            //             children: <Widget>[
            //               Text(
            //                 'Set Now',
            //                 style: TextStyle(
            //                   fontFamily: 'CalibriRegular',
            //                   fontSize: 14.0,
            //                   color: Colors.blue,
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: 5.0,
            //               ),
            //               Icon(
            //                 Icons.arrow_forward_ios,
            //                 size: 16.0,
            //                 color: Colors.grey,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //     Divider(
            //       height: 40.0,
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         Text(
            //           'Birthday',
            //           style: TextStyle(
            //             fontFamily: 'CalibriRegular',
            //             fontSize: 14.0,
            //           ),
            //         ),
            //         InkWell(
            //           onTap: () {},
            //           child: Row(
            //             children: <Widget>[
            //               Text(
            //                 'Set Now',
            //                 style: TextStyle(
            //                   fontFamily: 'CalibriRegular',
            //                   fontSize: 14.0,
            //                   color: Colors.blue,
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: 5.0,
            //               ),
            //               Icon(
            //                 Icons.arrow_forward_ios,
            //                 size: 16.0,
            //                 color: Colors.grey,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //     Divider(
            //       height: 40.0,
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         Text(
            //           'Phone',
            //           style: TextStyle(
            //             fontFamily: 'CalibriRegular',
            //             fontSize: 14.0,
            //           ),
            //         ),
            //         InkWell(
            //           onTap: () {},
            //           child: Row(
            //             children: <Widget>[
            //               Text(
            //                 'Set Now',
            //                 style: TextStyle(
            //                   fontFamily: 'CalibriRegular',
            //                   fontSize: 14.0,
            //                   color: Colors.blue,
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: 5.0,
            //               ),
            //               Icon(
            //                 Icons.arrow_forward_ios,
            //                 size: 16.0,
            //                 color: Colors.grey,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //     Divider(
            //       height: 40.0,
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         Text(
            //           'Email',
            //           style: TextStyle(
            //             fontFamily: 'CalibriRegular',
            //             fontSize: 14.0,
            //           ),
            //         ),
            //         InkWell(
            //           onTap: () {},
            //           child: Row(
            //             children: <Widget>[
            //               Text(
            //                 'ab******@gmail.com',
            //                 style: TextStyle(
            //                   fontFamily: 'CalibriRegular',
            //                   fontSize: 14.0,
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: 5.0,
            //               ),
            //               Text(
            //                 'Verify Now',
            //                 style: TextStyle(
            //                   fontFamily: 'CalibriRegular',
            //                   fontSize: 14.0,
            //                   color: Colors.blue,
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: 5.0,
            //               ),
            //               Icon(
            //                 Icons.arrow_forward_ios,
            //                 size: 16.0,
            //                 color: Colors.grey,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //     Divider(
            //       height: 40.0,
            //     ),
            //     InkWell(
            //       onTap: () {},
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: <Widget>[
            //           Text(
            //             'Set Password',
            //             style: TextStyle(
            //               fontFamily: 'CalibriRegular',
            //               fontSize: 14.0,
            //             ),
            //           ),
            //           Icon(
            //             Icons.arrow_forward_ios,
            //             size: 16.0,
            //             color: Colors.grey,
            //           ),
            //         ],
            //       ),
            //     ),
            //     Divider(
            //       height: 40.0,
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  String validateFirstName(String value) {
    if (value.isEmpty) {
      return AppTranslations.of(context).text('required');
    } else {
      if (value.length < 3)
        return AppTranslations.of(context).text('fnameError');
      else
        return null;
    }
  }

  String validateLastName(String value) {
    if (value.isEmpty) {
      return AppTranslations.of(context).text('required');
    } else {
      if (value.length < 3)
        return AppTranslations.of(context).text('lnameError');
      else
        return null;
    }
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return AppTranslations.of(context).text('required');
    } else {
      Pattern pattern = emailPattern;
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return AppTranslations.of(context).text('validMailError');
      else
        return null;
    }
  }

  String validatePh(String value) {
    if (value.length == 0)
      return AppTranslations.of(context).text('required');
    else
      return null;
  }

  Widget profileFormUI() {
    Gender g = widget.userData['user']['gender'] == "Male"
        ? Gender.Male
        : widget.userData['user']['gender'] == "Female"
            ? Gender.Female
            : null;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: GenderSelection(
            maleText: AppTranslations.of(context).text('male'), //default Male
            femaleText:
                AppTranslations.of(context).text('female'), //default Female
            selectedGenderIconBackgroundColor: PrimaryColor, // default red
            checkIconAlignment: Alignment.centerRight, // default bottomRight
            selectedGenderCheckIcon: null, // default Icons.check
            selectedGender: g,
            onChanged: (Gender gender) {
              // print(gender.toString().substring(7).trim());
              _gender = gender.toString().substring(7).trim();
            },
            equallyAligned: true,
            animationDuration: Duration(milliseconds: 400),
            isCircular: true, // default : true,
            isSelectedGenderIconCircular: true,
            opacityOfGradient: 0.6,
            padding: EdgeInsets.all(3),
            size: 80, //default : 120
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('first_name'),
            ),
            initialValue: widget.userData['user']['first_name'],
            validator: validateFirstName,
            onSaved: (val) => _fname = val,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(lnameFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('last_name'),
            ),
            initialValue: widget.userData['user']['last_name'],
            validator: validateLastName,
            onSaved: (val) => _lname = val,
            focusNode: lnameFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(emailFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: DateTimeField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('dob'),
            ),
            format: format,
            onSaved: (val) => _dob = val.toString(),
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            initialValue: widget.userData['user']['date_of_birth'] != null
                ? DateTime.parse(widget.userData['user']['date_of_birth'])
                : null,
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: DateTime.now(),
                lastDate: DateTime.now(),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('email'),
            ),
            initialValue: widget.userData['user']['email'],
            enabled: false,
            validator: validateEmail,
            onSaved: (val) => _email = val,
            focusNode: emailFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(mobileFocus);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                height: 60,
                margin: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CountryCodePicker(
                    onChanged: (e) => _countryCode = e.dialCode,
                    initialSelection: widget.userData['user']['country_code'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  initialValue: widget.userData['user']['mobile'],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppTranslations.of(context).text('mobile'),
                  ),
                  validator: validatePh,
                  onSaved: (val) => _mobile = val,
                  focusNode: mobileFocus,
                  onFieldSubmitted: (term) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ),
            ),
          ],
        ),
        // Container(
        //   padding: EdgeInsets.all(10),
        //   child: TextFormField(
        //     keyboardType: TextInputType.phone,
        //     textInputAction: TextInputAction.done,
        //     decoration: InputDecoration(
        //       border: OutlineInputBorder(),
        //       labelText: AppTranslations.of(context).text('mobile'),
        //     ),
        //     initialValue: widget.userData['user']['mobile'],
        //     validator: validatePh,
        //     onSaved: (val) => _mobile = val,
        //     focusNode: mobileFocus,
        //     onFieldSubmitted: (term) {
        //       FocusScope.of(context).requestFocus(FocusNode());
        //     },
        //   ),
        // ),
      ],
    );
  }
}
