class Notes {
  int _notID;
  String _noteContent;
  String catName;
  int _catID;
  String _noteTitle;
  String _noteDate;
  int _notStatus;

  Notes(this._noteContent, this._catID, this._noteTitle, this._noteDate,
      this._notStatus);

  Notes.withID(this._notID, this._noteContent, this._catID, this._noteTitle,
      this._noteDate, this._notStatus);

  int get ID {
    return _notID;
  }

  void set ID(int id) {
    _notID = id;
  }

  String get noteContent {
    return _noteContent;
  }

  void set noteContent(String notcontent) {
    _noteContent = notcontent;
  }

  int get catID {
    return _catID;
  }

  void set catID(int id) {
    _catID = id;
  }
  String get noteTitle {
    return _noteTitle;
  }

  void set noteTitle(String nottitle) {
    _noteTitle = nottitle;
  }

  String get noteDate {
    return _noteDate;
  }

  void set noteDate(String date) {
    _noteDate = date;
  }
  int get noteStatus {
    return _notStatus;
  }

  void set notStatus(int status) {
    _notStatus = status;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['notID'] = _notID;
    map['noteContent'] = _noteContent;
    map['catID'] = _catID;
    map['noteTitle'] = _noteTitle;
    map['noteDate'] = _noteDate;
    map['notStatus'] = _notStatus;
    return map;
  }

  Notes.fromMap(Map<String, dynamic> map) {
    _notID = map['notID'];
    _noteContent = map['noteContent'];
    _catID = map['catID'];
    catName = map['catName'];
    _noteTitle = map['noteTitle'];
    _noteDate = map['noteDate'];
    _notStatus = map['notStatus'];

  }
}
