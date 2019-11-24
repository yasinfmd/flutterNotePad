import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notepad/models/Category.dart';
import 'package:notepad/utils/dbhelper.dart';
import 'package:flushbar/flushbar.dart';

class Categorys extends StatefulWidget {
  @override
  _CategorysState createState() => _CategorysState();
}

class _CategorysState extends State<Categorys> {
  List<Category> allcategory;
  DataBaseHelper db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DataBaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (allcategory == null) {
      allcategory = List<Category>();
      fetchList();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Kategoriler"),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                delCat(context, allcategory[index].ID);
              },
              trailing: Icon(Icons.delete),
              title: Text(allcategory[index].catName),
            );
          },
          itemCount: allcategory.length,
        ),
      );
    }
  }

  void fetchList() {
    db.fetchfromclist().then((res) {
      setState(() {
        allcategory = res;
      });
    });
  }

  void delCat(BuildContext context, int catID) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Kategori Sil"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    "Kategori Silindiğinde Kategoriye Bağlı Notlarda Silinecektir... Devam Etmek İstiyor Musunuz ? "),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "Vazgeç",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Sil",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        db.deleteCategory(catID).then((res) {
                          if (res != 0) {
                            Navigator.pop(context);
                            setState(() {
                              fetchList();
                            });
                            Flushbar(
                              message: "Kategori Başarı İle Silindi",
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
                      },
                    )
                  ],
                )
              ],
            ),
          );
        });

    /* db.deleteCategory(catID).then((res) {
      if (res != 0) {
        Navigator.pop(context);
        Flushbar(
          message: "Kategori Başarı İle Silindi",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      }
    });*/
  }
}
