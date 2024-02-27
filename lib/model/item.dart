// ignore_for_file: unnecessary_this, unnecessary_null_comparison

class Item {
  late int id;
  late String title;
  late String description;

  Item();

  void fromMap(Map<String, dynamic> map) {
    if(map['id'] != null){
      this.id = map['id'];
    }
    this.title = map['title'];
    this.description = map['description'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'title' : this.title,
      'description' : this.description,
      'createdAt' : DateTime.now().toString(),
    };
    // if(id != null){
    //   map['id'] = this.id;
    // }
    return map; 
  }
}