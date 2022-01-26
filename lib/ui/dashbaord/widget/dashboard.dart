import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_practical_test/base/apis/api_url.dart';
import 'package:flutter_practical_test/base/constant.dart';
import 'package:flutter_practical_test/base/routes/routes.dart';
import 'package:flutter_practical_test/base/theme/images_link.dart';
import 'package:flutter_practical_test/ui/dashbaord/model/headline_model.dart';
import 'package:flutter_practical_test/ui/newsdescription/widget/description_page.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Constant.kNewsApp,
        ),
        actions: <Widget>[
          SizedBox(
            height: 35,
            child: PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              elevation: 10,
              icon: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      onError: (exception, stackTrace) {
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.green,
                          ),
                          child: const Center(
                              child: Text('UN',
                                  style: TextStyle(color: Colors.green))),
                        );
                      },
                      image: NetworkImage(Constant.loggedUserImage),
                      fit: BoxFit.fill),
                ),
              ),
              onSelected: (newValue) {
                if (newValue == 1) {
                  Constant.auth!.signOut();
                  Navigator.of(context).pushNamed(Routes.SIGN_IN);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    dense: true,
                    title: Text(
                      Constant.loggedUserName,
                      style: const TextStyle(
                          color: Colors.black, fontSize: 14, height: 1.5),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Text(
                          Constant.loggedUserEmail,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                            height: 1.5,
                          ),
                        )
                      ],
                    ),
                  ),
                  value: 0,
                ),
                PopupMenuItem(
                  enabled: true,
                  child: Text(
                    Constant.kSignOut,
                    style: TextStyle(
                      color: Colors.blueGrey[900],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  value: 1,
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        bottom: true,
        child: FutureBuilder(
          future: _headLineApi(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Sources>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (_, __) => const Divider(height: 5),
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return newsHeadLinesView(snapshot.data![index], index);
                },
              );
            }
          },
        ),
      ),
    );
  }

  // Call HeadLine Api
  Future<List<Sources>> _headLineApi() async {
    var url = Uri.parse('${ApiUrls.kBaseUrl}${ApiUrls.kNewsSource}${ApiUrls.kApiKey}');
    var response = await http.get(url);
    var responseData = json.decode(response.body);
    List<Sources> newsHeadLinesList = [];
    if (response.statusCode == 200) {
      for (var singleHeadLines in responseData['sources']) {
        Sources headLines = Sources(
            id: singleHeadLines["id"],
            name: singleHeadLines["name"],
            description: singleHeadLines["description"],
            url: singleHeadLines["url"],
            category: singleHeadLines["category"],
            language: singleHeadLines["language"],
            country: singleHeadLines["country"]);
        newsHeadLinesList.add(headLines);
      }
    }
    return newsHeadLinesList;
  }

  // Widget News HeadLine
  Widget newsHeadLinesView(Sources mData, int index) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: ()=> goToDescriptionPage(mData.id!),
                child: Column(
                  children: [
                    Text(mData.name!),
                    const SizedBox(height: 10),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(mData.description!)),
                    const SizedBox(height: 10),
                    Text(mData.url!),
                    const SizedBox(height: 10),
                    Text(mData.category!),
                  ],
                ),
              )),
          GestureDetector(
            onTap: () => bookmarkedFeed(mData),
            child: Image.asset(
              index == 0
                  ? ImagesLink.CHECK_BOOKMARK
                  : ImagesLink.UNCHECK_BOOKMARK,
              fit: BoxFit.cover,
              height: 30,
              width: 30,
            ),
          ),
        ],
      ),
    );
  }

  // Book marked feed with bookmark option
  bookmarkedFeed(Sources mData) {
    print(mData.name);
  }

  // Move to Description Page
  Future<void> goToDescriptionPage(String _id) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DescriptionPage(id: _id),
      ),
    );
  }
}
