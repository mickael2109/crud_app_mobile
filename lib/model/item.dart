// ignore_for_file: unnecessary_this, unnecessary_null_comparison

class Item {
  late int id;
  late String nom;

  Item();

  void fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nom = map['nom'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'nom' : this.nom
    };
    if(id != null){
      map['id'] = this.id;
      print('id io : ${this.id}');
    }
    return map; 
  }
}