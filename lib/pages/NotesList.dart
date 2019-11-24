import 'package:flutter/material.dart';
import 'package:notepad/models/Category.dart';
import 'package:notepad/pages/List.dart';
import 'package:notepad/pages/categoryList.dart';
import 'package:notepad/pages/newNotes.dart';
import 'package:notepad/utils/dbhelper.dart';
import 'package:flushbar/flushbar.dart';

class NotesList extends StatelessWidget {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Notlarım"),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    child: ListTile(
                  leading: Icon(Icons.category),
                  title: Text("Kategoriler"),
                  onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Categorys();
                    }));
                  },
                ))
              ];
            },
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "addcategory",
            onPressed: () {
              newCategoryDialog(context);
            },
            child: Icon(Icons.category),
            mini: true,
            tooltip: "Yeni Kategori Ekle",
          ),
          FloatingActionButton(
            heroTag: "addnote",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NoteDetail(
                  title: "Yeni Not Ekle",
                );
              }));
            },
            child: Icon(Icons.add_box),
            tooltip: "Not Oluştur",
          ),
        ],
      ),
      body: NList(),
    );
  }

  void newCategoryDialog(BuildContext context) {
    DataBaseHelper db = new DataBaseHelper();

    var formKey = GlobalKey<FormState>();

    String categoryName = "";

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Kategori Ekle",
                style: TextStyle(color: Colors.lightGreen)),
            children: <Widget>[
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    onSaved: (txt) {
                      categoryName = txt;
                    },

                    decoration: InputDecoration(
                        labelText: "Kategori Adı",
                        border: OutlineInputBorder()),
                    // ignore: missing_return
                    validator: (txt) {
                      if (txt.length < 3) {
                        return "Minimum 3 karakter giriniz..";
                      } else if (txt.trim() == "") {
                        return "Kategori Adı Giriniz";
                      }
                    },
                  ),
                ),
                autovalidate: true,
              ),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.red,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        db.createCategory(Category(categoryName)).then((catid) {
                          if (catid != 0) {
                            Navigator.pop(context);
                            Flushbar(
                              message: "$categoryName Başarı İle Eklendi",
                              icon: Icon(
                                Icons.info_outline,
                                size: 28.0,
                                color: Colors.blue[300],
                              ),
                              duration: Duration(seconds: 3),
                              leftBarIndicatorColor: Colors.blue[300],
                            )..show(context);
                          }
                        });
                      }
                    },
                    child: Text(
                      "Ekle",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                  )
                ],
              )
            ],
          );
        });
  }
}
