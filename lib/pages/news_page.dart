import 'package:flutter/material.dart';
import 'package:currency/heplers/app_constants.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:html_unescape/html_unescape.dart';

class NewsPage extends StatefulWidget {
  NewsPage(
      {Key key, this.title, this.articleTitle, this.content, this.imageURl})
      : super(key: key);

  final String title;
  final String content;
  final String imageURl;
  final String articleTitle;

  @override
  _NewsPageState createState() => new _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  var unescape = new HtmlUnescape();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: primaryColor, blurRadius: 5.0)],
                  // borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(10.0),
                  //     bottomRight: Radius.circular(10.0)),
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(widget.imageURl))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  widget.articleTitle,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 1.5,
                      wordSpacing: 3.0,
                      height: 1.5),
                ),
                SizedBox(
                  height: 10.0,
                ),

                // SingleChildScrollView(
                //   child: Center(
                //     child: HtmlTextView(data: widget.content),
                //   ),
                // )
                Text(
                  unescape.convert(widget.content),
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      fontSize: 16.0,
                      letterSpacing: 1.0,
                      wordSpacing: 2.0,
                      height: 1.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
