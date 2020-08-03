import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kushi/components/notification.dart';
import 'package:kushi/configs/config.select.sound.notification.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/pushproviders/push_notification_provider.dart';
import 'package:kushi/user/model/notification.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/repository/user.respository.dart';
import 'package:kushi/user/ui/screens/notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AppBarNotificatios extends StatefulWidget {
  UserModel user;
  GlobalKey<ScaffoldState> scaffoldKey;
  AppBarNotificatios({Key key, this.user, this.scaffoldKey});
  @override
  _AppBarNotificatiosState createState() => _AppBarNotificatiosState();
}

class _AppBarNotificatiosState extends State<AppBarNotificatios> {
  UserRepository _serviceKushiAPI;
  @override
  void initState() {
    notification();
    _serviceKushiAPI = Ioc.get<UserRepository>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _serviceKushiAPI.listNotificationViewAllUserRepository(
          widget.user.idCliente.toString()),
      builder: (_, AsyncSnapshot<List<NotificationModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return InkWell(
            child: Stack(
              children: <Widget>[
                Icon(
                  UiIcons.bell,
                  size: 27,
                  color: Theme.of(context).accentColor.withOpacity(1),
                ),
                Positioned(
                  top: 0,
                  right: 1,
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "0",
                      style: TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.circle),
                  ),
                )
              ],
            ),
            onTap: () {
              //updateNotifcationView(snapshot.data);
            },
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          return Consumer<InterceptApp>(
            builder: (context, InterceptApp value, Widget child) {
              return InkWell(
                child: Stack(
                  children: <Widget>[
                    Icon(
                      UiIcons.bell,
                      size: 27,
                      color: Theme.of(context).accentColor.withOpacity(1),
                    ),
                    Positioned(
                      top: 0,
                      right: 1,
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "${snapshot.data.length}",
                          style: TextStyle(color: Colors.white, fontSize: 10.0),
                        ),
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            shape: BoxShape.circle),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  if (value.lista().length == 0) {
                    updateNotifcationView(snapshot.data);
                  } else {
                    _showAlertDialog(
                      onPressed: () {
                        Provider.of<InterceptApp>(context)
                            .removeAllProductCart();
                        removeNotePreference();
                        updateNotifcationView(snapshot.data);
                      },
                    );
                  }
                },
              );
            },
          );
        } else {
          return InkWell(
            child: Stack(
              children: <Widget>[
                Icon(
                  UiIcons.bell,
                  size: 27,
                  color: Theme.of(context).accentColor.withOpacity(1),
                ),
                Positioned(
                  top: 0,
                  right: 1,
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "0",
                      style: TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.circle),
                  ),
                )
              ],
            ),
            onTap: () {
              updateNotifcationView(snapshot.data);
            },
          );
        }
      },
    );
  }

  void notification() {
    final pushNotification = new PushNotificationProvider();
    pushNotification.initNotifications();
    pushNotification.mensaje.listen((data) {
      if (data == 'Notification1998') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                NotificationsWidget(user: widget.user),
          ),
        );
      } else {
        alertNotification(data);
      }
    });
  }

  void alertNotification(String data) {
    sonidoNotification();
    widget.scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: NotificationContext(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    NotificationsWidget(user: widget.user),
              ),
            );
          },
          data: data,
        ),
        duration: Duration(milliseconds: 9000),
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void sonidoNotification() {
    AudioCache player = new AudioCache();
    player.play(SOUND.doorbell);
  }

  void updateNotifcationView(List<NotificationModel> data) {
    if (data.length > 0) {
      for (var items in data) {
        runUpdatedNotification(items);
      }
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              NotificationsWidget(user: widget.user),
        ),
      );
    }
  }

  void runUpdatedNotification(NotificationModel model) {
    NotificationModel newmodel = new NotificationModel();
    newmodel.keyDocument = model.keyDocument;
    newmodel.idBusiness = model.idBusiness;
    newmodel.click = model.click;
    newmodel.bussines = model.bussines;
    newmodel.codData = model.codData;
    newmodel.description = model.description;
    newmodel.date = model.date;
    newmodel.iconNotification = model.iconNotification;
    newmodel.image = model.image;
    newmodel.view = 1;
    newmodel.viewItem = model.viewItem;
    newmodel.typeNotification = model.typeNotification;
    newmodel.sound = model.sound;
    newmodel.name = model.name;
    _serviceKushiAPI
        .updatedNotiicationViewAll(newmodel, widget.user.idCliente.toString())
        .then(
      (value) {
        if (value == true) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  NotificationsWidget(user: widget.user),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  NotificationsWidget(user: widget.user),
            ),
          );
        }
      },
    );
  }

  void _showAlertDialog({VoidCallback onPressed}) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            '¡' +
                'Hay productos en el carrito de esta tienda y se eliminaran, ya que no puede comprar otros productos que no sea de aquí.',
            style: TextStyle(fontSize: 12),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('¿Seguro que desea salir?'),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'SI',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: onPressed,
            ),
            CupertinoDialogAction(
              child: Text(
                'NO',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void removeNotePreference() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove('notePaymentUser');
  }
}
