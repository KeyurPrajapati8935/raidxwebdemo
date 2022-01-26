import 'dart:convert';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical_test/base/apis/api_url.dart';
import 'package:flutter_practical_test/base/constant.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_practical_test/ui/newsdescription/model/news_list_model.dart';
import 'package:http/http.dart' as http;

class DescriptionPage extends StatefulWidget {

  final String? id;

  const DescriptionPage({Key? key, this.id}) : super(key: key);

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  late ScrollController _controller;

  int pageSize = 10;
  int page = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List newsList = [];

  @override
  void initState() {
    super.initState();
    _getNewsList();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constant.kNewsDesc),
      ),
      body: _isFirstLoadRunning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _controller,
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ExpansionTileCard(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(newsList[index].urlToImage.toString().isNotEmpty ? newsList[index].urlToImage : 'https://qa-pms.qualitycop.in/Images/userImages/UnAssignedImg.png'),
                          ),
                          title: Column(
                            children: [
                              Text(newsList[index].title!),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Column(
                                  children: [
                                    Html(data: newsList[index].description!),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // when the _loadMore function is running
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // When nothing else to load
                if (_hasNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    color: Colors.amber,
                    child: const Center(
                      child: Text(Constant.kFetchAllContent),
                    ),
                  ),
              ],
            ),
    );
  }

  // Call NewsList with title & description
  void _getNewsList() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      var url = Uri.parse('${ApiUrls.kBaseUrl}${ApiUrls.kNewsListUrl}${widget.id}&pageSize=$pageSize&page=$page&${ApiUrls.kApiKey}');
      var response = await http.get(url);
      setState(() {});
      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var singleHeadLines in responseData['articles']) {
          Articles newsLines = Articles(
              author: singleHeadLines["author"],
              title: singleHeadLines["title"],
              description: singleHeadLines["description"],
              url: singleHeadLines["url"],
              urlToImage: singleHeadLines["urlToImage"],
              publishedAt: singleHeadLines["publishedAt"],
              content: singleHeadLines["content"]);
          newsList.add(newsLines);
        }
      }
      // ignore: empty_catches
    } catch (err) {}

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // Load more records after finish 10 records
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      page += 1;
      try {
        final response = await http.get(Uri.parse('${ApiUrls.kBaseUrl}${ApiUrls.kNewsListUrl}${widget.id}&pageSize=$pageSize&page=$page&${ApiUrls.kApiKey}'));

        var responseData = json.decode(response.body);

        if (responseData != null) {
          for (var singleHeadLines in responseData['articles']) {
            Articles newsLines = Articles(
                author: singleHeadLines["author"],
                title: singleHeadLines["title"],
                description: singleHeadLines["description"],
                url: singleHeadLines["url"],
                urlToImage: singleHeadLines["urlToImage"],
                publishedAt: singleHeadLines["publishedAt"],
                content: singleHeadLines["content"]);
            newsList.add(newsLines);
          }
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
        // ignore: empty_catches
      } catch (err) {}

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }
}
