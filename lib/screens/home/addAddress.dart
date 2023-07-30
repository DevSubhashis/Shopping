import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:ppl/providers/user.dart';
import 'package:ppl/screens/profile/sign_in.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:provider/provider.dart';

ProgressDialog pr;

class AddAdressScreen extends StatefulWidget {
  final selectedAddress;
  AddAdressScreen({Key key, this.selectedAddress}) : super(key: key);
  @override
  _AddAdressScreenState createState() => _AddAdressScreenState();
}

class _AddAdressScreenState extends State<AddAdressScreen> {
  final GlobalKey<FormState> _addAddressFormKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();

  final personFocus = FocusNode();
  final contactFocus = FocusNode();
  final addressFocus = FocusNode();
  final postCodeFocus = FocusNode();
  final countryFocus = FocusNode();
  final stateFocus = FocusNode();
  final cityFocus = FocusNode();
  //final zillaFocus = FocusNode();
  final upsazillaFocus = FocusNode();
  final municipalityFocus = FocusNode();
  final villageFocus = FocusNode();
  final unionFocus = FocusNode();
  final unitFocus = FocusNode();

  String _addressName;
  String _personName;
  String _contactNo;
  String _address;
  String _postCode;
  String _country;
  int _country_id;
  String _state;
  int _state_id;
  String _city;
  int _city_id;
  // String _zilla;
  String _upsazilla;
  int _sub_city_id;
  String _municipality;
  String _village;
  String _union;
  String _floor;
  String _unit;
  bool isSetDefaultAddress = false;
  int address_id = 0;
  String _countryCode;

  bool _autoValidate = false;

  TextEditingController _txtAddrNameController = TextEditingController();
  TextEditingController _txtPersonNameController = TextEditingController();
  TextEditingController _txtContactController = TextEditingController();
  TextEditingController _txtCityController = TextEditingController();
  TextEditingController _txtStreetAddrController = TextEditingController();
  TextEditingController _txtUnitController = TextEditingController();
  TextEditingController _txtPostController = TextEditingController();
  TextEditingController _txtStateController = TextEditingController();
  TextEditingController _txtCountryController = TextEditingController();
  TextEditingController _txtUpzillaController = TextEditingController();
  TextEditingController _txtMunicController = TextEditingController();
  TextEditingController _txtVillController = TextEditingController();
  TextEditingController _txtUninController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.selectedAddress != null)
      _fetchAddressDetails(widget.selectedAddress);
  }

  _fetchAddressDetails(selectedAddress) {
    print(selectedAddress.address_id);
    print(selectedAddress.sub_city_name);
    print(selectedAddress.person_name);
    Map addressObj = json.decode(selectedAddress.street_address);
    String addressStr = addressObj['street_address'];
    String floor = addressObj['floor'];
    String unit = addressObj['unit'];
    setState(() {
      _txtAddrNameController.text = selectedAddress.address_name;
      _addressName = selectedAddress.address_name;
      _txtPersonNameController.text = selectedAddress.person_name;
      _personName = selectedAddress.person_name;
      _txtContactController.text = selectedAddress.contact_number;
      _contactNo = selectedAddress.contact_number;
      _txtStreetAddrController.text = addressStr;
      _address = addressStr;
      // _floor = floor;
      _txtUnitController.text = unit;
      _unit = unit;
      _txtPostController.text = selectedAddress.zip_code;
      _postCode = selectedAddress.zip_code;
      _txtCountryController.text = selectedAddress.country_name;
      _country_id = selectedAddress.country_id;
      _country = selectedAddress.country_name;
      _txtStateController.text = selectedAddress.state_name;
      _state = selectedAddress.state_name;
      _state_id = selectedAddress.state_id;
      _txtCityController.text = selectedAddress.city_name;
      _city = selectedAddress.city_name;
      _city_id = selectedAddress.city_id;
      _txtUpzillaController.text = selectedAddress.sub_city_name;
      _upsazilla = selectedAddress.sub_city_name;
      _sub_city_id = selectedAddress.sub_city_id;
      _txtMunicController.text = selectedAddress.municipal;
      _municipality = selectedAddress.municipal;
      _txtVillController.text = selectedAddress.village;
      _village = selectedAddress.village;
      _txtUninController.text = selectedAddress.union;
      _union = selectedAddress.union;
      isSetDefaultAddress = selectedAddress.is_primary;
      address_id = selectedAddress.address_id;
    });
  }

  void doValidate() {
    if (_addAddressFormKey.currentState.validate()) {
      _addAddressFormKey.currentState.save();

      if (widget.selectedAddress != null) {
        updateAddAdress();
      } else {
        doAddAdress();
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void updateAddAdress() {
    print("====== updateAddAdress =========== >>>>>>>>>>>>>>> ");
    var user = Provider.of<UserModel>(context, listen: false);
    pr.show();
    Map addressObj = {
      "street_address": _address,
    };
    if (_floor != null) {
      addressObj.addAll({"floor": _floor});
    }
    if (_unit != null && _unit != '') {
      addressObj.addAll({"unit": _unit});
    }
    String addressStr = json.encode(addressObj);
    Map body = {
      'address_name': _addressName.toString(),
      'person_name': _personName.toString(),
      "contact_number": _contactNo.toString(),
      "street_address": addressStr.toString(),
      "country_id": _country_id,
      "state_id": _state_id,
      "city_id": _city_id,
      'sub_city_id': _sub_city_id,
      'union': _union,
      "municipal": _municipality,
      "village": _village,
      "upojila": _upsazilla,
      'zip_code': _postCode.toString(),
      'make_default': isSetDefaultAddress
    };

    WebService api = WebService();
    var URL = EDIT_ADDRESS + "/" + address_id.toString();
    final response =
        api.callPatchAPI(URL, body, user.userData['auth']['_token']);
    response.then((value) {
      //print(value.body);
      if (pr.isShowing()) {
        pr.hide();
      }
      var decodedData = jsonDecode(value.body);
      print(decodedData);
      final int statusCode = decodedData['serverResponse']['code'];
      final String message = decodedData['serverResponse']['message'];
      if (statusCode != 200) {
        this._showDialogError(message);
      } else {
        this._showDialogSuccess(message);
      }
    }).catchError((onError) {
      if (pr.isShowing()) {
        pr.hide();
      }
      this._showDialogError(onError);
    });
  }

  getLocationByZipCode(String query) {
    print("getLocationByZipCode " + query);
    WebService api = WebService();
    var URL = GET_LOCATIO0N_BY_ZIP_CODE + '/' + query;
    final response = api.callGetAPI(URL, '');

    response.then((value) {
      print(value.body);
      var decodedData = jsonDecode(value.body);
      final int statusCode = decodedData['serverResponse']['code'];
      if (statusCode != 200) {
      } else {
        final String cityName = decodedData['result']['city_name'];
        final String stateName = decodedData['result']['state_name'];
        final String countryName = decodedData['result']['country_name'];
        final String upaZillaName = decodedData['result']['sub_city_name'];

        final int country_id = decodedData['result']['country_id'];
        final int state_id = decodedData['result']['state_id'];
        final int city_id = decodedData['result']['city_id'];
        final int sub_city_id = decodedData['result']['sub_city_id'];

        setState(() {
          _city = cityName;
          _state = stateName;
          _country = countryName;
          _upsazilla = upaZillaName;
          _country_id = country_id;
          _state_id = state_id;
          _city_id = city_id;
          _sub_city_id = sub_city_id;
        });
        _txtCityController.text = cityName;
        _txtStateController.text = stateName;
        _txtCountryController.text = countryName;
        _txtUpzillaController.text = upaZillaName;
      }
    }).catchError((onError) {});
  }

  void doAddAdress() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var user = Provider.of<UserModel>(context, listen: false);
      pr.show();
      Map addressObj = {
        "street_address": _address,
      };
      if (_floor != null) {
        addressObj.addAll({"floor": _floor});
      }
      if (_unit != null && _unit != '') {
        addressObj.addAll({"unit": _unit});
      }
      String addressStr = json.encode(addressObj);
      Map body = {
        'address_name': _addressName.toString(),
        'person_name': _personName.toString(),
        "contact_number": _contactNo.toString(),
        "street_address": addressStr.toString(),
        "country_id": _country_id,
        "state_id": _state_id,
        "city_id": _city_id,
        'sub_city_id': _sub_city_id,
        'union': _union,
        "municipal": _municipality,
        "village": _village,
        "upojila": _upsazilla,
        'zip_code': _postCode.toString(),
        'make_default': isSetDefaultAddress,
        "country_code": _countryCode
      };
      // print(body);
      // print(ADD_ADDRESS);
      // print(user.userData['auth']['_token']);
      WebService api = WebService();
      final response =
          api.callPostAPI(ADD_ADDRESS, body, user.userData['auth']['_token']);
      response.then((value) {
        //print(value.body);
        if (pr.isShowing()) {
          pr.hide();
        }
        var decodedData = jsonDecode(value.body);
        print(decodedData);
        final int statusCode = decodedData['serverResponse']['code'];
        final String message = decodedData['serverResponse']['message'];
        if (statusCode != 200) {
          this._showDialogError(message);
        } else {
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

  void doDeleteAdress() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var user = Provider.of<UserModel>(context, listen: false);
      pr.show();
      WebService api = WebService();
      final response = api.callDeleteAPI(
          DELETE_ADDRESS + '/' + widget.selectedAddress.address_id.toString(),
          user.userData['auth']['_token']);
      response.then((value) {
        //print(value.body);
        if (pr.isShowing()) {
          pr.hide();
        }
        var decodedData = jsonDecode(value.body);
        final int statusCode = decodedData['serverResponse']['code'];
        final String message = decodedData['serverResponse']['message'];
        if (statusCode != 200) {
          this._showDialogError(message);
        } else {
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
          title: new Text(AppTranslations.of(context).text('success')),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(AppTranslations.of(context).text('ok')),
              onPressed: () {
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SigninScreen()),
                // );
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
          title: new Text(AppTranslations.of(context).text('error')),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(AppTranslations.of(context).text('close')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String validateFunction(String value) {
    if (value.isEmpty) {
      return AppTranslations.of(context).text('required');
    } else {
      return null;
    }
  }

  Widget addAddress() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: _txtAddrNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('enter_address_name'),
            ),
            validator: validateFunction,
            onSaved: (val) => _addressName = val,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(personFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: _txtPersonNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('enter_person_name'),
            ),
            validator: validateFunction,
            onSaved: (val) => _personName = val,
            focusNode: personFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(contactFocus);
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
                    initialSelection: 'BD',
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
                  controller: _txtContactController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText:
                        AppTranslations.of(context).text('enter_your_contact'),
                  ),
                  validator: validateFunction,
                  onSaved: (val) => _contactNo = val,
                  focusNode: contactFocus,
                  onFieldSubmitted: (term) {
                    FocusScope.of(context).requestFocus(addressFocus);
                  },
                ),
              ),
            ),
          ],
        ),
        // Container(
        //   padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        //   child: TextFormField(
        //     keyboardType: TextInputType.phone,
        //     textInputAction: TextInputAction.next,
        //     controller: _txtContactController,
        //     decoration: InputDecoration(
        //       border: OutlineInputBorder(),
        //       labelText: AppTranslations.of(context).text('enter_your_contact'),
        //     ),
        //     validator: validateFunction,
        //     onSaved: (val) => _contactNo = val,
        //     focusNode: contactFocus,
        //     onFieldSubmitted: (term) {
        //       FocusScope.of(context).requestFocus(addressFocus);
        //     },
        //   ),
        // ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: _txtStreetAddrController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('enter_your_address'),
            ),
            validator: validateFunction,
            onSaved: (val) => _address = val,
            focusNode: addressFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(unitFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                hint: Text(
                  AppTranslations.of(context).text('select_floor'),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'MontserratRegular',
                  color: Colors.grey,
                ),
                value: _floor,
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    _floor = newValue;
                  });
                },
                items: [
                  "1st Floor",
                  "2nd Floor",
                  "3rd Floor",
                  "4th Floor",
                  "5th Floor",
                  "6th Floor",
                  "7th Floor",
                  "8th Floor",
                  "9th Floor",
                  "10th Floor"
                ].map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: _txtUnitController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Unit',
            ),
            // validator: validateFunction,
            onSaved: (val) => _unit = val,
            focusNode: unitFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(postCodeFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: _txtPostController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppTranslations.of(context).text('post_code'),
              ),
              validator: validateFunction,
              onSaved: (val) => _postCode = val,
              focusNode: postCodeFocus,
              onFieldSubmitted: (term) {
                print(term);
                getLocationByZipCode(term);
                FocusScope.of(context).requestFocus(municipalityFocus);
              },
              onChanged: (query) {
                if (query.length > 4) {
                  getLocationByZipCode(query);
                }
              }),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            enabled: false,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: _txtCountryController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('enter_your_country'),
            ),
            validator: validateFunction,
            onSaved: (val) => _country = val,
            focusNode: countryFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(stateFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            enabled: false,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: _txtStateController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('enter_your_state'),
            ),
            validator: validateFunction,
            onSaved: (val) => _state = val,
            focusNode: stateFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(cityFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            enabled: false,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: _txtCityController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('enter_your_city'),
            ),
            validator: validateFunction,
            onSaved: (val) => _city = val,
            focusNode: cityFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(upsazillaFocus);
            },
          ),
        ),
        // Container(
        //   padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        //   child: TextFormField(
        //     keyboardType: TextInputType.text,
        //     textInputAction: TextInputAction.next,
        //     decoration: InputDecoration(
        //       border: OutlineInputBorder(),
        //       labelText: AppTranslations.of(context).text('enter_your_zilla'),
        //     ),
        //     validator: validateFunction,
        //     onSaved: (val) => _zilla = val,
        //     focusNode: zillaFocus,
        //     onFieldSubmitted: (term) {
        //       FocusScope.of(context).requestFocus(upsazillaFocus);
        //     },
        //   ),
        // ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            enabled: false,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: _txtUpzillaController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('enter_your_upzilla'),
            ),
            validator: validateFunction,
            onSaved: (val) => _upsazilla = val,
            focusNode: upsazillaFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(municipalityFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: _txtMunicController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('municipality'),
            ),
            //validator: validateFunction,
            onSaved: (val) => _municipality = val,
            focusNode: municipalityFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(villageFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            controller: _txtVillController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('village'),
            ),
            // validator: validateFunction,
            onSaved: (val) => _village = val,
            focusNode: villageFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(unionFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            controller: _txtUninController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('enter_union_name'),
            ),
            // validator: validateFunction,
            onSaved: (val) => _union = val,
            focusNode: unionFocus,
            onFieldSubmitted: (term) {
              this.doValidate();
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTranslations.of(context).text('select_default'),
              ),
              Switch(
                value: isSetDefaultAddress,
                onChanged: (value) {
                  setState(() {
                    isSetDefaultAddress = value;
                    print(isSetDefaultAddress);
                  });
                },
                activeTrackColor: PrimaryColor,
                activeColor: PrimaryColor,
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 20.0),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: RaisedButton(
            textColor: Colors.white,
            splashColor: Colors.white,
            color: PrimaryColor,
            child: Text(
              widget.selectedAddress == null
                  ? AppTranslations.of(context).text('save_address')
                  : AppTranslations.of(context).text('update_address'),
              style: TextStyle(
                fontFamily: 'CalibriRegular',
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              this.doValidate();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
              AppTranslations.of(context).text('save_address'),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'CalibriBold',
                fontSize: 16.0,
              ),
            ),
          ),
          actions: [
            if (widget.selectedAddress != null)
              FlatButton(
                onPressed: () {
                  _showConfirmDialog(context);
                },
                child: Text(
                  AppTranslations.of(context).text('delete_address'),
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _addAddressFormKey,
          autovalidate: _autoValidate,
          child: addAddress(),
        ),
      ),
    );
  }

  Future<AlertDialog> _showConfirmDialog(BuildContext context) {
    return showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          title: Text(
            AppTranslations.of(context).text('confirm'),
          ),
          content: Text(
            AppTranslations.of(context).text('deleteConfirm'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                AppTranslations.of(context).text('yes'),
                style: TextStyle(
                  fontSize: 18.0,
                  color: PrimaryColor,
                ),
              ),
              onPressed: () {
                doDeleteAdress();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                AppTranslations.of(context).text('no'),
                style: TextStyle(
                  fontSize: 18.0,
                  color: SecondaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
