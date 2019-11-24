import 'package:flutter/material.dart';
import 'package:notepad/models/Notes.dart';
import 'package:notepad/pages/newNotes.dart';
import 'package:notepad/utils/dbhelper.dart';
import 'package:flushbar/flushbar.dart';

class NList extends StatefulWidget {
  @override
  _NListState createState() => _NListState();
}

class _NListState extends State<NList> {
  List<Notes> allNotes;
  DataBaseHelper db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allNotes = List<Notes>();
    db = DataBaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.fetchfromlist(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          allNotes = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, index) {
              return Dismissible(
                background: Container(
                  color: Colors.green,
                  child: Align(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        Text(
                          " Düzenle",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Align(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        Text(
                          " Sil",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
                // ignore: missing_return
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                "${allNotes[index].noteTitle} Başlıklı Notu Silmek İstiyor Musun?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "Hayır",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "Evet",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  db
                                      .deleteNotes(allNotes[index].ID)
                                      .then((res) {
                                    if (res != 0) {
                                      Navigator.of(context).pop();
                                      String title = allNotes[index].noteTitle;
                                      Flushbar(
                                        message: "$title Başarı İle Silindi",
                                        icon: Icon(
                                          Icons.info_outline,
                                          size: 28.0,
                                          color: Colors.blue[300],
                                        ),
                                        duration: Duration(seconds: 3),
                                        leftBarIndicatorColor: Colors.blue[300],
                                      )..show(context);
                                      setState(() {});
                                    }
                                  });

                                  //
                                },
                              ),
                            ],
                          );
                        });
                    return res;
                  } else {
                    navigateDetail(context, allNotes[index]);
                    // TODO: Navigate to edit page;
                  }
                },
                child: Card(
                  child: ListTile(
                    onLongPress: () {
                      openContentDialog(context, allNotes[index].noteContent);
                    },
                    leading: CircleAvatar(
                      child: allNotes[index].noteStatus == 0
                          ? Text(
                              "D",
                              style: TextStyle(color: Colors.white),
                            )
                          : (allNotes[index].noteStatus == 1
                              ? Text(
                                  "O",
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  "Y",
                                  style: TextStyle(color: Colors.white),
                                )),
                      backgroundColor: allNotes[index].noteStatus == 0
                          ? Colors.green.shade400
                          : (allNotes[index].noteStatus == 1
                              ? Colors.amber.shade400
                              : Colors.red.shade400),
                    ),
                    title: Text(allNotes[index].noteTitle),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(allNotes[index].catName),
                        Text(db.dateFormat(
                            DateTime.parse(allNotes[index].noteDate))),
                      ],
                    ),
                  ),
                ),
                key: Key(index.toString()),
              );
            },
            itemCount: allNotes.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void openContentDialog(BuildContext context, String content) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title:
                Text("Not İçeriği", style: TextStyle(color: Colors.lightGreen)),
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: SingleChildScrollView(child: Text(content)),
                  ))
            ],
          );
        });
  }

  void navigateDetail(BuildContext context, Notes notes) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(title: "Notu Düzenle", editedNote: notes);
    }));
  }
}
