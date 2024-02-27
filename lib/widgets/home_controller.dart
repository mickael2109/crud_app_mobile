// ignore_for_file: prefer_const_constructors, unnecessary_new, sort_child_properties_last, prefer_is_empty, unnecessary_null_comparison, unused_field

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:p5_app_with_sqlite/model/item.dart';
import 'package:p5_app_with_sqlite/widgets/donnees_vides.dart';
import 'package:p5_app_with_sqlite/model/databaseClient.dart';
import 'package:p5_app_with_sqlite/widgets/itemDetail.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key, required this.title});

  final String title;

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {

  List<Item> items = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    await SQLHelper.getAlls().then((items) => {
      setState(() {
        this.items = items;
        _isLoading = false;
      })
    });
  }

  @override
  void initState(){
    super.initState();
    _refreshJournals();
  }


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


  Future<void> _addItem() async {
    Map<String, dynamic> map = {'title': _titleController.text, 'description': _descriptionController.text};
    Item item = new Item();
    item.fromMap(map);
    await SQLHelper.createItem(item);
    _refreshJournals();
  }


  Future<void> _updateItem(int id) async {
    Map<String, dynamic> map = {'title': _titleController.text, 'description': _descriptionController.text};
    Item item = new Item();
    item.fromMap(map);
    await SQLHelper.updateItem(id, item);

    _refreshJournals();
  }


  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id, 'items');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully delete a journal!'),));
    _refreshJournals();
  }


  void _showForm(int? id) async{
    if(id != null){
      final existingJournal =
        items.firstWhere((item) => item.id == id);
        _titleController.text = existingJournal.title;
        _descriptionController.text = existingJournal.description;
    }
    showModalBottomSheet(
      context: context, 
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15.0,
          left: 15.0,
          right: 15.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 10.0,
            ),

            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(
              height: 20.0,
            ), 
            ElevatedButton(
              onPressed: () async {
                if(id == null){
                  await _addItem();
                }
                if(id != null){
                  await _updateItem(id);
                }

                // Clear the text fields
                _titleController.text = '';
                _descriptionController.text = '';

                Navigator.of(context).pop();
              }, 
              child: Text(id == null ? 'Create New' : "Update"),
              )
          ],
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.title),
        foregroundColor: Colors.white,
        actions: <Widget>[
          new OutlinedButton (
            onPressed: () => _showForm(null),
            child: new Text("Ajouter", style: new TextStyle(color: Colors.white)),
            style: new ButtonStyle(
              side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
              // Ici, nous spécifions une bordure transparente
            ),
            ),
        ],
      ),
    
      body: (items == null || items.length == 0 )
        ? new DonnesVides() 
        : new ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i){
          Item item = items[i];
          return new ListTile(
            title: new Text(item.title),
            trailing: new IconButton( onPressed: () => _deleteItem(item.id), icon: const Icon(Icons.delete)),
            leading: new IconButton(onPressed: (() => _showForm(item.id)), icon: new Icon(Icons.edit)),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext buildContext){
                return new ItemDetail(item);
              }));
            },
          );
        }
      ),
    );
  }
}
