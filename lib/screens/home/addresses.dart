import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppl/screens/profile/sign_in.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/screens/home/addAddress.dart';
import 'package:ppl/models/Address.dart';
import 'package:ppl/providers/user.dart';
import 'package:provider/provider.dart';

ProgressDialog pr;

class AddressesScreen extends StatefulWidget {
  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<Address> addresses = [];
  Address selectedAddress;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllAddresses();
  }

  getAllAddresses() {
    var user = Provider.of<UserModel>(context, listen: false);
    // setState(() {
    //   isLoading = true;
    // });
    WebService api = WebService();
    final response =
        api.callGetAPI(GET_ALL_ADDRESS, user.userData['auth']['_token']);
    response.then((value) {
      print(value.body);
      setState(() {
        isLoading = false;
      });
      var decodedData = jsonDecode(value.body);
      final int statusCode = decodedData['serverResponse']['code'];
      final String message = decodedData['serverResponse']['message'];
      if (statusCode == 400) {
      } else if (statusCode == 401) {
        this._showDialogError(message);
        user.doRemoveUser();
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        List objsJson = decodedData['result'] as List;
        List<Address> addrObjs =
            objsJson.map((addrJson) => Address.fromJson(addrJson)).toList();
        print(addrObjs);
        setState(() {
          addresses = addrObjs;
        });
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  // setDefaultAddress() {
  //   pr.show();
  //   var user = Provider.of<UserModel>(context, listen: false);
  //   WebService api = WebService();
  //   var URL = SET_DEFAULT_ADDRESS + "/" + selectedAddress.address_id.toString();
  //   final response = api.callPatchAPI(URL, user.userData['auth']['_token']);
  //   response.then((value) {
  //     print(value.body);
  //     if (pr.isShowing()) {
  //       pr.hide();
  //     }
  //     var decodedData = jsonDecode(value.body);
  //     final int statusCode = decodedData['serverResponse']['code'];
  //     final String message = decodedData['serverResponse']['message'];
  //     if (statusCode == 400) {
  //       this._showDialogError(message);
  //     } else if (statusCode == 401) {
  //       this._showDialogError(message);
  //       user.doRemoveUser();
  //       Navigator.of(context).popUntil((route) => route.isFirst);
  //     } else {
  //       this._showDialogSuccess(message);
  //       getAllAddresses();
  //     }
  //   }).catchError((onError) {
  //     if (pr.isShowing()) {
  //       pr.hide();
  //     }
  //     this._showDialogError(onError);
  //   });
  // }

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
                Navigator.of(context).pop();
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

  // setSelectedAddress(Address address) {
  //   setState(() {
  //     selectedAddress = address;
  //   });
  //   setDefaultAddress();
  // }

  List<Widget> createAddressView() {
    List<Widget> widgets = [];
    for (Address address in addresses) {
      Map addressObj = json.decode(address.street_address);
      String addressStr = addressObj['street_address'] + ',';
      String floor =
          addressObj['floor'] != null ? '(${addressObj['floor']}),' : '';
      String unit =
          addressObj['unit'] != null ? 'Unit: ${addressObj['unit']},' : '';
      String upzilla =
          address.sub_city_name != null ? '${address.sub_city_name},' : '';
      String municipality =
          address.municipal != null ? '${address.municipal},' : '';
      String village = address.village != null ? '${address.village},' : '';
      String union = address.union != null ? '${address.union},' : '';
      widgets.add(
        Card(
          child: Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: ListTile(
              // value: address,
              // groupValue: selectedAddress,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddAdressScreen(selectedAddress: address)),
                ).then((value) {
                  getAllAddresses();
                });
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(address.person_name +
                        " (" +
                        address.contact_number +
                        ") "),
                  ),
                  if (address.is_primary)
                    Text(
                      AppTranslations.of(context).text('default'),
                      style: TextStyle(color: Colors.blue),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '$addressStr $floor $unit $upzilla $municipality $village $union ${address.city_name}, ${address.state_name}, ${address.country_name} ${address.zip_code}'),
                ],
              ),
              // onChanged: (currentUser) {
              //   setSelectedAddress(currentUser);
              // },
              // selected: address.is_primary,
              // activeColor: Colors.green,
            ),
          ),
        ),
      );
    }
    return widgets;
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
              AppTranslations.of(context).text('addresses'),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'CalibriBold',
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: isLoading
            ? circularProgress()
            : Column(children: <Widget>[
                Column(
                  children: createAddressView(),
                ),
                // Container(
                //   height: 50,
                //   width: MediaQuery.of(context).size.width,
                //   margin: EdgeInsets.only(top: 20.0),
                //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                //   child: RaisedButton(
                //     textColor: Colors.white,
                //     splashColor: Colors.white,
                //     color: PrimaryColor,
                //     child: Text(
                //       AppTranslations.of(context).text('set_default_address'),
                //       style: TextStyle(
                //         fontFamily: 'CalibriRegular',
                //         fontSize: 14.0,
                //         color: Colors.white,
                //       ),
                //     ),
                //     onPressed: () {
                //       setDefaultAddress();
                //     },
                //   ),
                // ),
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
                      AppTranslations.of(context).text('add_address'),
                      style: TextStyle(
                        fontFamily: 'CalibriRegular',
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddAdressScreen(selectedAddress: null)),
                      ).then((value) {
                        getAllAddresses();
                      });
                    },
                  ),
                ),
              ]),
      ),
    );
  }

  circularProgress() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 5,
            bottom: MediaQuery.of(context).size.height / 5),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(SecondaryColor),
        ),
      ),
    );
  }
}
