class Category {
  int _catID;
  String _catName;

  Category(this._catName);
  Category.withID(this._catID, this._catName);
  int get ID {
    return _catID;
  }

  void set ID(int id) {
    _catID = id;
  }

  String get catName {
    return _catName;
  }

  void set catName(String catname) {
    _catName = catname;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['catID'] = _catID;
    map['catName'] = _catName;
    return map;
  }

  Category.fromMap(Map<String, dynamic> map) {
    this._catID = map['catID'];
    this.catName = map['catName'];
  }
  @override
  String toString() {
    return "Category{catID:$_catID,catName:$_catName}";
  }
}
