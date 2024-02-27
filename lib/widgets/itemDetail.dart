// ignore_for_file: no_logic_in_create_state, unused_element, use_key_in_widget_constructors, prefer_initializing_formals, unnecessary_new, prefer_const_constructors, prefer_is_empty, prefer_const_literals_to_create_immutables, unnecessary_this

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:p5_app_with_sqlite/model/article.dart';
import 'package:p5_app_with_sqlite/model/item.dart';
import 'package:p5_app_with_sqlite/widgets/ajout_article.dart';
import 'package:p5_app_with_sqlite/model/databaseClient.dart';
import 'package:p5_app_with_sqlite/widgets/donnees_vides.dart';
import 'package:image_picker/image_picker.dart';


class ItemDetail extends StatefulWidget {
  late Item item;
  
  ItemDetail(Item item){
    this.item = item;
  }


  @override
  State<StatefulWidget> createState() => new _ItemDetailState();

}

class _ItemDetailState extends State<ItemDetail> {

  List<Article> articles = [];
  String image = '';
  String nom = '';
  String magasin = '';
  String prix = '';
  bool _isLoading = true;


  @override
  void initState(){
    super.initState();
    _refreshPage();
  }

   void _refreshPage() async {
    await SQLHelper.allArticles(widget.item.id).then((listeArticle) => {
      setState(() {
        this.articles = listeArticle;
        _isLoading = false;
      })
    });
  }

  @override
  Widget build(BuildContext context) {

    double tailleWidth = MediaQuery.of(context).size.width * 0.40;
    double tailleHeight = MediaQuery.of(context).size.width * 0.20;
    
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text(widget.item.title),
        foregroundColor: Colors.white,
        actions: <Widget>[
          new OutlinedButton(
            onPressed: () {
              _showFormArticle(null);
              // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext buildContext) {
              //   return new Ajout(widget.item.id);
              // } ));
            }, 
            child: new Text("Ajout Article", style: new TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: (articles == null || articles.length == 0)
        ? new DonnesVides()
        : new GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: articles.length,
            itemBuilder: ((context, index) {
              Article article = articles[index];
              return new Card(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(article.nom),
                    (article.image == '')
                      ? new Image.asset('images/no_image.jpg' , fit: BoxFit.cover, height: tailleHeight, width: tailleWidth,)
                      : new Image.file(new File(article.image) , fit: BoxFit.cover, height: tailleHeight,width: tailleWidth,),
                      new Text((article.image == '') ? 'Aucun prix renseigné' : "Prix : ${article.prix}"),
                      new Text((article.magasin == '') ? 'Aucun magasin renseigné' : "Magasin : ${article.magasin}")
                  ],
                ),
              );
            }),
          ),
    );
  }

  void _showFormArticle(int? id) async {

    double tailleWidth = MediaQuery.of(context).size.width * 0.60;
    double tailleHeight = MediaQuery.of(context).size.width * 0.40;
    
    showModalBottomSheet(
      context: context, 
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15.0,
          left: 15.0,
          right: 15.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            (image == '')
              ? new Image.asset('images/no_image.jpg', fit: BoxFit.cover, height: tailleHeight, width: tailleWidth,)
              : new Image.file(new File(image), fit: BoxFit.cover, height: tailleHeight, width: tailleWidth,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new IconButton(onPressed: (() => getImage(ImageSource.camera)), icon: Icon(Icons.camera_enhance)),
                new IconButton(onPressed: (() => getImage(ImageSource.gallery)), icon: Icon(Icons.photo_library)),
              ],
            ),
            textField(TypeTextField.nom, 'Nom de l\'article'),
            textField(TypeTextField.prix, 'Prix'),
            textField(TypeTextField.magasin, 'Magasin'),

            ElevatedButton(
              onPressed: () async {
                if(id == null){
                  await _addArticle();
                }
                if(id != null){

                }
                nom = "";
                prix = "";
                magasin = "";
                image = "";
                Navigator.of(context).pop();
              }, 
              child: Text("Valider"),
              )
          ],
        ),
      ));
  }


  Future<void> _addArticle() async {
    Map<String, dynamic> map = {
      'nom': nom, 
      'item': widget.item.id,
      'magasin': magasin,
      'prix': prix,
      'image': image,
    };
    Article article = new Article();
    article.fromMap(map);
    await SQLHelper.createArticle(article);
    _refreshPage();
  }


  Future getImage(ImageSource source) async {
    var nouvelleImage = await ImagePicker.platform.pickImage(source: source);
    setState(() {
      print("nouvelleImage1 : ${nouvelleImage?.path}");
      image = nouvelleImage!.path;
      print("nouvelleImage2 : ${nouvelleImage.path}");
      print("image : $image");
    });
  }

  TextField textField(TypeTextField type, String label){
    return new TextField(
      decoration: new InputDecoration(hintText: label),
      onChanged: (String string) {
        switch(type){
          case TypeTextField.nom:
            nom = string;
            break;
          case TypeTextField.prix:
            prix = string;
            break;
          case TypeTextField.magasin:
            magasin = string;
            break;
        }
      },
    );
  }

}

enum TypeTextField {nom, prix, magasin}