import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical_test/base/constant.dart';
import 'package:flutter_practical_test/base/sql_helper.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {

  List<Map<String, dynamic>> empRole = [];
  bool _isLoading = true;
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _compnayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: const Text(Constant.kDashboard),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: empRole.length,
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                margin: const EdgeInsets.all(15),
                child: ListTile(
                    title: Text(empRole[index]['designation']),
                    subtitle: Text(empRole[index]['company']),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(empRole[index]['id']),
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }

  void _getList() async {
    final data = await SQLHelper.getItems();
    setState(() {
      empRole = data;
      _isLoading = false;
    });
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
      empRole.firstWhere((element) => element['id'] == id);
      _designationController.text = existingJournal['designation'];
      _compnayController.text = existingJournal['company'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        builder: (_) => Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _designationController,
                  decoration: const InputDecoration(
                      hintText: Constant.kDesignation),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _compnayController,
                  decoration:
                  const InputDecoration(hintText: Constant.kCompany),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Save new journal
                    if (id == null) {
                      await _addItem();
                    }

                    if (id != null) {
                      await _updateItem(id);
                    }

                    // Clear the text fields
                    _designationController.text = '';
                    _compnayController.text = '';

                    // Close the bottom sheet
                    Navigator.of(context).pop();
                  },
                  child: Text(
                      id == null ? Constant.kCreate : Constant.kUpdate),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        "", "", "", _designationController.text, _compnayController.text);
    _getList();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _designationController.text, _compnayController.text);
    _getList();
  }
}
