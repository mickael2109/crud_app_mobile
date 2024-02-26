// ignore_for_file: prefer_const_constructors, unnecessary_new, sort_child_properties_last

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:p5_app_with_sqlite/model/item.dart';
import 'package:p5_app_with_sqlite/widgets/donnees_vides.dart';
import 'package:p5_app_with_sqlite/model/databaseClient.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key, required this.title});

  final String title;

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {

  // String nouvelleListe='';
  // List<Item> items = [];
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    _refreshJournals();
    print("... number of items ${_journals.length}");
    // recuperer();
  }


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _addItem() async {
    await SQLHelper.createItem(
      _titleController.text, 
    _descriptionController.text
    );
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
      id,_titleController.text,_descriptionController.text
    );
    _refreshJournals();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully delete a journal!'),));
    _refreshJournals();
  }


  void _showForm(int? id) async{
    if(id != null){
      final existingJournal =
        _journals.firstWhere((element) => element['id'] == id);
        _titleController.text = existingJournal['title'];
        _descriptionController.text = existingJournal['description'];
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        
        // actions: <Widget>[
        //   new OutlinedButton (
        //     onPressed: ajouter, 
        //     child: new Text("Ajouter", style: new TextStyle(color: Colors.white)),
        //     style: new ButtonStyle(
        //       side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
        //       // Ici, nous spécifions une bordure transparente
        //     ),
        //     ),
        // ],
      ),
      
      body: ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(_journals[index]['title']),
            subtitle: Text(_journals[index]['description']),
            trailing: SizedBox(
              width: 100.0,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _showForm(_journals[index]['id']), 
                    icon: const Icon(Icons.edit)
                  ),
                  IconButton(
                    onPressed: () => _deleteItem(_journals[index]['id']), 
                    icon: const Icon(Icons.delete)
                  ),
                ],
              ),
            ),
          ),
        )
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null)
      ),
      
      // body: (items == null || items.length == 0 )
      //   ? new DonnesVides() 
      //   : new ListView.builder(
      //     itemCount: items.length,
      //     itemBuilder: (context, i){
      //       Item item = items[i];
      //       return new ListTile(
      //         title: new Text(item.nom),
      //       );
      //     }
      //   )
    );
  }

  // Future<Null> ajouter() async {
  //   await showDialog(
  //     context: context, 
  //     barrierDismissible: false,
  //     builder: (BuildContext buildContext) {
  //       return new AlertDialog(
  //         title: new Text('Ajouter une liste de souhaits'),
  //         content: new TextField(
  //           decoration: new InputDecoration(
  //             labelText: "liste:",
  //             hintText: "ex: mes prochains jeux vidéos",
  //           ),
  //           onChanged: (String str) {
  //             nouvelleListe = str;
  //           },
  //         ),
  //         actions: <Widget>[
  //           new OutlinedButton(
  //             onPressed: (() => Navigator.pop(buildContext)), 
  //             child: new Text("Annuler"),
  //             style: new ButtonStyle(
  //               side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
  //             ),
  //           ),
  //           new OutlinedButton(
  //             onPressed: (() {
  //               if(nouvelleListe != null){
  //                 print('ios $nouvelleListe');
  //                 Map<String, dynamic> map = {'nom': nouvelleListe};
  //                 Item item = new Item();
  //                 print('io io io : $map');
  //                 item.fromMap(map);
  //                 DatabaseClient().ajoutItem(item).then((i) => recuperer());
  //                 nouvelleListe = '';
  //               }
  //               Navigator.pop(buildContext);
  //             }), 
  //             child: new Text("Valider", style: new TextStyle(color: Colors.blue),),
  //             style: new ButtonStyle(
  //               side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void recuperer() {
  //   DatabaseClient().allItem().then((items) {
  //     setState(() {
  //       this.items = items;
  //     });
  //   });
  // }
}
