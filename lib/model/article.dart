// ignore_for_file: unnecessary_this

class Article{

  late int id;
  late String nom;
  late int item;
  late var prix;
  late String magasin;
  late String image;

  Article();

  void fromMap(Map<String, dynamic> map) {
    if(map['id'] != null){
      this.id = map['id'];
    }
    this.nom = map['nom'];
    this.item = map['item'];
    this.prix = map['prix'];
    this.magasin = map['magasin'];
    this.image = map['image'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'nom': this.nom,
      'item': this.item,
      'magasin': this.magasin,
      'prix':this.prix,
      'image': this.image,
      'createdAt' : DateTime.now().toString(),
    };
    return map;
  }

}