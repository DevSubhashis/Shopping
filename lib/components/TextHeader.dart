import 'package:flutter/material.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/screens/categories/categories.dart';

class TextHeader extends StatelessWidget {
  final String textString;
  final String type;

  static var subHeaderCustomStyle = TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.w700,
    fontFamily: "CalibriBold",
    fontSize: 16.0,
  );

  TextHeader({@required this.textString, @required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(
            textString,
            style: TextStyle(color: Colors.blue, fontFamily: 'CalibriBold'),
          ),
          InkWell(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.0, right: 3.0),
                    child: Text(
                      AppTranslations.of(context).text('see_more'),
                      style: subHeaderCustomStyle.copyWith(
                          color: Colors.indigoAccent, fontSize: 14.0),
                    ),
                  ),
                  onTap: () {
                    if (type == 'top_categories') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoriesScreen(from: "home"),
                        ),
                      );
                    } else if (type == 'trending_brands') {
                    } else if (type == 'feature_products') {}
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 2.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18.0,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
