import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:ppl/models/ReviewItem.dart';
import 'package:ppl/components/ReviewBlock.dart';
import 'package:ppl/presentation/custom_icons_icons.dart';
import 'package:ppl/screens/home/cart.dart';
import 'package:ppl/utils/constants.dart';

final List<ReviewItem> reviewItems = [
  new ReviewItem(
    '4',
    '16th July, 1987',
    'After a lot of research I finally purchased Samsung and this product was launched in last year.',
    'https://randomuser.me/api/portraits/men/46.jpg',
  ),
  new ReviewItem(
      '4',
      '16th July, 1987',
      'After a lot of research I finally purchased Samsung and this product was launched in last year.',
      'https://randomuser.me/api/portraits/men/46.jpg'),
  new ReviewItem(
      '4',
      '16th July, 1987',
      'After a lot of research I finally purchased Samsung and this product was launched in last year.',
      'https://randomuser.me/api/portraits/men/46.jpg'),
  new ReviewItem(
      '4',
      '16th July, 1987',
      'After a lot of research I finally purchased Samsung and this product was launched in last year.',
      'https://randomuser.me/api/portraits/men/46.jpg'),
  new ReviewItem(
      '4',
      '16th July, 1987',
      'After a lot of research I finally purchased Samsung and this product was launched in last year.',
      'https://randomuser.me/api/portraits/men/46.jpg'),
  new ReviewItem(
    '4',
    '16th July, 1987',
    'After a lot of research I finally purchased Samsung and this product was launched in last year.',
    'https://randomuser.me/api/portraits/men/46.jpg',
  ),
  new ReviewItem(
      '4',
      '16th July, 1987',
      'After a lot of research I finally purchased Samsung and this product was launched in last year.',
      'https://randomuser.me/api/portraits/men/46.jpg'),
  new ReviewItem(
      '4',
      '16th July, 1987',
      'After a lot of research I finally purchased Samsung and this product was launched in last year.',
      'https://randomuser.me/api/portraits/men/46.jpg'),
  new ReviewItem(
      '4',
      '16th July, 1987',
      'After a lot of research I finally purchased Samsung and this product was launched in last year.',
      'https://randomuser.me/api/portraits/men/46.jpg'),
  new ReviewItem(
      '4',
      '16th July, 1987',
      'After a lot of research I finally purchased Samsung and this product was launched in last year.',
      'https://randomuser.me/api/portraits/men/46.jpg')
];

class AllReview extends StatefulWidget {
  @override
  AllReviewState createState() => AllReviewState();
}

class AllReviewState extends State<AllReview> {
  @override
  Widget build(BuildContext context) {
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
              'Product Blazer',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'CalibriBold',
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: new ListView(
          children: reviewItems
              .map(
                (item) => new ReviewBlock(
                    date: item.date,
                    details: item.review,
                    changeRating: (rating) {},
                    image: item.avatar),
              )
              .toList(),
        ),
      ),
    );
  }
}
