// ignore_for_file: prefer_const_constructors, unnecessary_new, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class DonnesVides extends StatelessWidget {
   
  @override
  Widget build(BuildContext context){
    return new Center(
      child: new Text("Aucune donné n'est présente",
      textScaleFactor: 2.5,
      textAlign: TextAlign.center,
      style: new TextStyle(
        color: Colors.red,
        fontStyle: FontStyle.italic
      ),

      ),
    );
  }

}