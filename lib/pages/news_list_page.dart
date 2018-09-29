import 'package:flutter/material.dart';
import 'package:currency/heplers/news.dart';
import 'package:currency/heplers/app_constants.dart';
import 'package:currency/pages/news_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:async';
import 'package:currency/heplers/connectivity.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NewsListPage extends StatefulWidget {
  NewsListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewsListPageState createState() => new _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<News> parseNews(String responseBody) {
    final parsed = json.decode(responseBody);
    final jsonData = (parsed['response']['data']).cast<Map<String, dynamic>>();
    return jsonData.map<News>((json) => News.fromJson(json)).toList();
  }

  Future<List<News>> fetchNews() async {
    var client = http.Client();
    try {
      final response =
          await client.get(newsAPI);

      // return compute(parseNews, response.body);
      return parseNews(response.body);
    } catch (e) {
      return null;
    }
  }

  @override
  initState() {
    super.initState();
  }

  Future<Null> refreshData() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      checkConnection(context);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.title,
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<List<News>>(
            future: fetchNews(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final news1 = snapshot.data[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => NewsPage(
                                      title: 'Новости',
                                      articleTitle: news1.title,
                                      content: news1.description,
                                      imageURl: news1.fieldImage,
                                    )));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                            height: 250.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                    color: primaryColor, blurRadius: 3.0)
                              ],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: PhysicalModel(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                fit: BoxFit.cover,
                                image: news1.fieldImage,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            child: Text(
                              news1.description,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0)),
                            alignment: Alignment.bottomRight,
                            child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: accentColor,
                                child: MaterialButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Читать далее',
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => NewsPage(
                                                  title: 'Новости',
                                                  articleTitle: news1.title,
                                                  content:
                                                      news1.description
                                                          ,
                                                  imageURl: news1.fieldImage,
                                                )));
                                  },
                                )),
                          ),
                          Divider(
                            color: primaryColor,
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                print('{$snapshot.error}');
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
