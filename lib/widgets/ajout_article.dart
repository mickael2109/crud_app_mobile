// ignore_for_file: unused_element, use_key_in_widget_constructors, prefer_initializing_formals, unnecessary_new, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';

class Ajout extends StatefulWidget {

  late int id;
  Ajout(int id){
    this.id = id;
  }

  @override
  State<StatefulWidget> createState() => new _AjoutState();

}

class _AjoutState extends State<Ajout> {
  
  String image = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text("Ajouter"),
        foregroundColor: Colors.white,
        actions: <Widget>[
          new OutlinedButton(
            onPressed: null, 
            child: new Text("Valider", style: new TextStyle(color: Colors.white),)
          )
        ],
      ),

      body: new SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          children: <Widget>[
            new Text('Article à ajouter', textScaleFactor: 1.4, style: new TextStyle(color: Colors.red, fontStyle: FontStyle.italic),),
            new Card(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  (image == '')
                    ? new Image.asset('images/no_image.jpg')
                    : new Image.file(new File(image)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new IconButton(onPressed: null, icon: Icon(Icons.camera_enhance)),
                      new IconButton(onPressed: null, icon: Icon(Icons.photo_library)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}