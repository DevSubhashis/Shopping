import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class ReviewBlock extends StatelessWidget {
  final String date;
  final String details;
  final Function changeRating;
  final String image;

  ReviewBlock(
      {@required this.date,
      @required this.details,
      @required this.changeRating,
      @required this.image});

  static var detailText = TextStyle(
      fontFamily: "CalibriRegular",
      color: Colors.black54,
      letterSpacing: 0.3,
      wordSpacing: 0.5,
      fontSize: 12);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 45.0,
        width: 45.0,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
      ),
      title: Row(
        children: <Widget>[
          StarRating(
            size: 20.0,
            rating: 3.5,
            starCount: 5,
            color: Colors.yellow,
            onRatingChanged: changeRating,
          ),
          SizedBox(width: 8.0),
          Text(
            date,
            style: TextStyle(fontSize: 12.0),
          )
        ],
      ),
      // subtitle: Text(
      //   details,
      //   style: detailText,
      // ),
      subtitle: Column(
        children: <Widget>[
          Text(
            details,
            style: detailText,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(right: 20.0, top: 10.0),
                child: Image.network(
                    "https://images-na.ssl-images-amazon.com/images/I/71ObKBNLg8L._CR0,204,1224,1224_UX175.jpg",
                    fit: BoxFit.cover),
              ),
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(right: 20.0, top: 10.0),
                child: Image.network(
                    "https://images-na.ssl-images-amazon.com/images/I/71ObKBNLg8L._CR0,204,1224,1224_UX175.jpg",
                    fit: BoxFit.cover),
              )
            ],
          )
        ],
      ),
    );
  }
}
