import 'package:flutter/material.dart';
import 'package:ppl/utils/constants.dart';

class CartSingle extends StatefulWidget {
  final Map item;
  final void Function(bool) callback;

  CartSingle({@required this.item, this.callback});

  @override
  _CartSingleState createState() => _CartSingleState();
}

class _CartSingleState extends State<CartSingle> {
  Map<String, bool> numbers = {};

  void callCallaback(bool i) {
    print(i);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 5.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: PrimaryColor,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: Text(
                      'Mall',
                      style: TextStyle(
                        fontFamily: 'CalibriLight',
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Under Armour Official Store",
                    style: TextStyle(
                      fontFamily: 'CalibriBold',
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 14.0,
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  onChanged: (bool value) {
                    setState(() {
                      numbers['${widget.item['product_id']}'] = value;
                    });
                  },
                  value: numbers['${widget.item['product_id']}'] ?? false,
                  checkColor: Colors.greenAccent,
                  activeColor: Colors.red,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.item['product_image'],
                    height: 70.0,
                    width: 70.0,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.item['product_name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.blue,
                            fontFamily: 'CalibriRegular',
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "\৳${widget.item['maximum_retail_price']}",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                                fontFamily: 'CalibriRegular',
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              "\৳${widget.item['selling_price']}",
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontFamily: 'CalibriBold',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                        Container(
                          child: Text(
                            "${double.parse(widget.item['discount'].toString()).toStringAsFixed(0)}% Off",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontFamily: 'CalibriBold',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                        Row(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: null,
                              child: Icon(
                                Icons.remove,
                                color: Colors.black87,
                              ),
                              backgroundColor: Colors.white,
                              mini: true,
                              onPressed: () {},
                            ),
                            SizedBox(
                              width: 14.0,
                            ),
                            Text("1",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.blue,
                                  fontFamily: 'Montserrat',
                                )),
                            SizedBox(
                              width: 14.0,
                            ),
                            FloatingActionButton(
                              heroTag: null,
                              child: Icon(
                                Icons.add,
                                color: Colors.black87,
                              ),
                              backgroundColor: Colors.white,
                              mini: true,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Free Shipping on orders from \৳10.00",
                    style: TextStyle(
                      fontFamily: 'CalibriRegular',
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
