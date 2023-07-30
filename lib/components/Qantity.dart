import 'package:flutter/material.dart';

class Qantity extends StatelessWidget {
  final Function(int) refreshQuantity;
  final int numberOfItems;

  Qantity({@required this.numberOfItems, @required this.refreshQuantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            width: 50,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0)), // set rounded corner radius
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, color: Colors.black, offset: Offset(1, 3))
                ] // make rounded corner of border
                ),
            child: InkWell(
              onTap: () {
                if (numberOfItems != 1) {
                  this.refreshQuantity(numberOfItems - 1);
                }
              },
              child: Center(
                child: Text(
                  "-",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Montserrat',
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            width: 200,
            decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0)), // set rounded corner radius
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      color: Colors.blue[100],
                      offset: Offset(1, 3))
                ] // make rounded corner of border
                ),
            child: Center(
              child: Text(
                numberOfItems.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Montserrat',
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            width: 50,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0)), // set rounded corner radius
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, color: Colors.black, offset: Offset(1, 3))
                ] // make rounded corner of border
                ),
            child: InkWell(
              onTap: () {
                this.refreshQuantity(numberOfItems + 1);
              },
              child: Center(
                child: Text(
                  "+",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Montserrat',
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
