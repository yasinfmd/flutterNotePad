import 'package:flutter/material.dart';
import 'package:notepad/models/Category.dart';
import 'package:notepad/pages/List.dart';
import 'package:notepad/pages/categoryList.dart';
import 'package:notepad/pages/newNotes.dart';
import 'package:notepad/utils/dbhelper.dart';
import 'package:flushbar/flushbar.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FlutterLocalNotificationsPlugin notification;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    notification = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings("app_icon");
    var ios = new IOSInitializationSettings();
    var initsettings = new InitializationSettings(android, ios);
    notification.initialize(initsettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Selam Müdür Bildirime Tıkladım"),
              content: Text(payload),
            ));
  }

  @override
  Widget build(BuildContext context) {
    showNotification("Unutma Push Notification", "Tarihe Bak");
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






     var android =new AndroidNotificationDetails("1", "S1", "S2",ticker: "ticker",color: Colors.blue,   importance: Importance.Max,priority: Priority.High);
    var ios=new IOSNotificationDetails();
    var platform=new NotificationDetails(android, ios);
    await notification.show(0, title, text,  platform,payload: "Tıklayınca Gösterilen Bildirim İçeriği");

  }
}
