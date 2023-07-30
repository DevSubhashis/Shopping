import 'package:flutter/material.dart';
import 'package:ppl/screens/home/productDetails.dart';
import 'package:ppl/localization/app_translations.dart';

class ProductSingle extends StatelessWidget {
  final id;
  final imageUrl;
  final name;
  final price;
  // final String rating;
  // final bool isInDiscount;
  // final String discount;
  final decription;

  ProductSingle(
      {Key key, this.id, this.decription, this.imageUrl, this.name, this.price})
      : super(key: key);

  // ProductSingle({
  //   @required this.id,
  //   @required this.imageUrl,
  //   @required this.name,
  //   @required this.price,
  //   // @required this.rating,
  //   // @required this.isInDiscount,
  //   // @required this.discount,
  //   @required this.decription,
  // });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetails(productId: id),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(62, 168, 174, 201),
                offset: Offset(0, 9),
                blurRadius: 14,
              ),
            ],
          ),
          child:
              //ClipRRect(
              // borderRadius: BorderRadius.circular(10),
              // child: Banner(
              //   message: "10% " + AppTranslations.of(context).text('off'),
              //   location: BannerLocation.topStart,
              //   color: Colors.red,
              //   child:
              Stack(
            children: <Widget>[
              Image.network(imageUrl,
                  height: 220, width: 200, fit: BoxFit.cover),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 100,
                    width: 200,
                    decoration: BoxDecoration(
                      // Box decoration takes a gradient
                      gradient: LinearGradient(
                        // Where the linear gradient begins and ends
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        // Add one stop for each color. Stops should increase from 0 to 1
                        colors: [
                          // Colors are easy thanks to Flutter's Colors class.
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.025),
                        ],
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container())),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$name \n',
                          style: TextStyle(
                              fontSize: 18, fontFamily: 'CalibriBold'),
                        ),

                        TextSpan(
                          text: '\৳${price.toString()} \n',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CalibriBold',
                          ),
                        ),
                        // TextSpan(
                        //   text: '\$${678} \n',
                        //   style: TextStyle(
                        //       fontSize: 16,
                        //       fontFamily: 'CalibriRegular',
                        //       decoration: TextDecoration.lineThrough),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 20,
              //   right: 5,
              //   child: Row(
              //     children: <Widget>[
              //       Text(
              //         "4.4",
              //         style: TextStyle(
              //             color: Colors.white, fontFamily: 'CalibriBold'),
              //       ),
              //       new Icon(
              //         Icons.star,
              //         color: Colors.white,
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
          // ),
          // ),
        ),
      ),
    );
  }
}
