import 'package:flutter/material.dart';
import 'package:flutter_practical_test/base/constant.dart';
import 'package:flutter_practical_test/base/theme/images_link.dart';
import 'package:flutter_practical_test/ui/dashbaord/model/news_model.dart';
import 'package:hive/hive.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {

  late Box box;
  List<Task> bookMarkList = [];

  @override
  void initState() {
    super.initState();
    getEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Constant.kBookmarkPage,
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        bottom: true,
        child: ListView.separated(
          separatorBuilder: (_, __) => const Divider(height: 5),
          itemCount: bookMarkList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return bookMarkHeadLines(bookMarkList[index], index);
          },
        ),
      ),
    );
  }

  Widget bookMarkHeadLines(
    Task bookMarkList,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(bookMarkList.name!),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(bookMarkList.description!)),
                  const SizedBox(height: 10),
                  Text(bookMarkList.url!),
                  const SizedBox(height: 10),
                  Text(bookMarkList.category!),
                ],
              )),
          Image.asset(
            ImagesLink.CHECK_BOOKMARK,
            fit: BoxFit.cover,
            height: 30,
            width: 30,
          ),
        ],
      ),
    );
  }

  // Get local stored list
  void getEmployees() async {
    final box = await Hive.openBox<Task>('newsDB');
    setState(() {
      bookMarkList = box.values.toSet().toList();
    });
  }
}
