import 'package:flutter/material.dart';
import 'package:notepad/models/Category.dart';
import 'package:notepad/models/Notes.dart';
import 'package:notepad/utils/dbhelper.dart';
import 'package:flushbar/flushbar.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";

class NoteDetail extends StatefulWidget {
  String title = "";
  Notes editedNote;

  NoteDetail({this.title, this.editedNote});

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  FlutterLocalNotificationsPlugin notification;
  var formKey = GlobalKey<FormState>();
  DataBaseHelper db;
  List<Category> allCategory;
  int selected = 1;
  int selectedl = 0;
  String noteTitle, noteContent;

  static var _list = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allCategory = List<Category>();
    db = DataBaseHelper();
    notification=new FlutterLocalNotificationsPlugin();
    var android =new AndroidInitializationSettings("app_icon");
    var ios=new IOSInitializationSettings();
    var initsettings=new InitializationSettings(android, ios);
    notification.initialize(initsettings,onSelectNotification: selectNotification);


    //kategorileri al listeye nesneye çevirip ekle
    db.fetchCategory().then((catList) {
      for (Map item in catList) {
        allCategory.add(Category.fromMap(item));
      }
      setState(() {});
    });
  }
    Future selectNotification(String payload){
      showDialog(context: context,builder: (_)=>AlertDialog(
        title: Text("Selam Müdür Bildirime Tıkladım"),
        content: Text(payload),
      ));
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Form(
            autovalidate: true,
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: Center(
                      child: Text(
                    "Kategori Seçiniz..",
                  )),
                  margin: EdgeInsets.only(top: 20),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: DropdownButtonHideUnderline(
                      child: allCategory.length <= 0
                          ? CircularProgressIndicator()
                          : DropdownButton<int>(
                              isExpanded: true,
                              value: widget.editedNote != null
                                  ? widget.editedNote.catID
                                  : selected,
                              items: createCategoryItem(),
                              onChanged: (catID) {
                                setState(() {
                                  selected = catID;
                                });
                              },
                            ),
                    ),
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                Container(
                  child: TextFormField(
                    initialValue: widget.editedNote != null
                        ? widget.editedNote.noteTitle
                        : "",
                    validator: (txt) {
                      if (txt.trim() == "") {
                        return "Lütfen Başlık Giriniz";
                      }
                    },
                    onSaved: (txt) {
                      noteTitle = txt;
                    },
                    decoration: InputDecoration(
                        hintText: "Not Başlığı",
                        labelText: "Başlık",
                        border: OutlineInputBorder()),
                  ),
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.all(10),
                ),
                Container(
                  child: TextFormField(
                    initialValue: widget.editedNote != null
                        ? widget.editedNote.noteContent
                        : "",
                    maxLines: 5,
                    onSaved: (txt) {
                      noteContent = txt;
                    },
                    decoration: InputDecoration(
                        hintText: "Not İçeriği",
                        labelText: "İçerik",
                        border: OutlineInputBorder()),
                  ),
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.all(10),
                ),
                Container(
                  child: Center(
                      child: Text(
                    "Öncelik..",
                  )),
                  margin: EdgeInsets.only(top: 20),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: widget.editedNote != null
                            ? widget.editedNote.noteStatus
                            : selectedl,
                        items: _list.map((item) {
                          return DropdownMenuItem<int>(
                            value: _list.indexOf(item),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: item == "Düşük"
                                          ? Colors.green.shade400
                                          : (item == "Orta"
                                              ? Colors.amber.shade400
                                              : Colors.red.shade400),
                                    ),
                                  ],
                                ),
                                Text(item)
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (listid) {
                          setState(() {
                            selectedl = listid;
                          });
                        },
                      ),
                    ),
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.red.shade400,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Vazgeç",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.lightGreen.shade400,
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          if (widget.editedNote == null) {
                            db
                                .createNotes(Notes(
                                    noteContent,
                                    selected,
                                    noteTitle,
                                    DateTime.now().toString(),
                                    selectedl))
                                .then((res) {
                              if (res != 0) {
                                Navigator.pop(context);
                                showNotification("Not Oluşturuldu","$noteTitle ' adlı yeni bir not oluşturdunuz :)");
                                Flushbar(
                                  message: "$noteTitle Başarı İle Eklendi",
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
                          else {
                            db
                              .updateNotes(Notes.withID(
                                widget.editedNote.ID,
                                  noteContent,
                                  selected,
                                  noteTitle,
                                  DateTime.now().toString(),
                                  selectedl))
                              .then((res) {
                            if (res != 0) {
                              Navigator.pop(context);
                              Flushbar(
                                message: "$noteTitle Başarı İle Düzenlendi",
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
                        }

                      },
                      child: Text(
                        "Kaydet",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          scrollDirection: Axis.vertical,
        ));
  }

  List<DropdownMenuItem<int>> createCategoryItem() {
    return allCategory
        .map((cat) => DropdownMenuItem<int>(
            value: cat.ID,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    cat.catName,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            )))
        .toList();
  }

  Future<void> showNotification(title,text) async{
    /*var scheduledNotificationDateTime =
    new DateTime.now().add(new Duration(seconds: 5));
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('your other channel id',
        'your other channel name', 'your other channel description');
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notification.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);*/


    /*var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('repeating channel id',
        'repeating channel name', 'repeating description');
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notification.periodicallyShow(0, title,
        text, RepeatInterval.EveryMinute, platformChannelSpecifics);*/






   /* var android =new AndroidNotificationDetails("1", "S1", "S2",ticker: "ticker",color: Colors.blue,   importance: Importance.Max,priority: Priority.High);
    var ios=new IOSNotificationDetails();
    var platform=new NotificationDetails(android, ios);
    await notification.show(0, title, text,  platform,payload: "Tıklayınca Gösterilen Bildirim İçeriği");*/

  }
}
