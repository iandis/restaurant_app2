
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:restaurant_app2/models/_models.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();
final didReceiveLocalNotificationSubject = BehaviorSubject<NotificationModel>();

class NotificationService extends GetxService{
  static const _channelId = "01";
  static const _channelName = "Restaurant App";
  static const _channelDesc = "Avo Projects - Restaurant App";
 
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void onInit() async {
    super.onInit();
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    requestIOSPermissions();
    await _initNotifications();
  }

  Future<void> _initNotifications() async {

    var initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
    
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:  (id, title, body, payload) async {
        didReceiveLocalNotificationSubject.add(
          NotificationModel(
            id: id, 
            title: title, 
            body: body, 
            payload: payload
          )
        );
      }
    );
    
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, 
        iOS: initializationSettingsIOS
    );
    
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        if (payload != null) {
          print('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload);
      }
    );
  }

  void requestIOSPermissions() {
      _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void configureSelectNotificationSubject(void Function(String) onData) {
    selectNotificationSubject.stream.listen(onData);
  }

  void configureDidReceiveLocalNotificationSubject(void Function(NotificationModel) onData) {
    didReceiveLocalNotificationSubject.stream.listen(onData);
   }

  Future<void> showNotification({
    @required NotificationModel notificationModel
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId, 
      _channelName, 
      _channelDesc,
      importance: Importance.max, 
      priority: Priority.high, 
      ticker: 'ticker',
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, 
      iOS: iOSPlatformChannelSpecifics
    );

    await _flutterLocalNotificationsPlugin.show(
      notificationModel.id, 
      notificationModel.title, 
      notificationModel.body, 
      platformChannelSpecifics,
      payload: notificationModel.payload
    );
  }

  Future<void> scheduleNotification({
    @required NotificationModel notificationModel, 
    @required tz.TZDateTime dateTime,
    bool daily = false,
    String icon,
    Int64List vibrationPattrn,
  }) async {

    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDesc,
      icon: icon ?? 'ic_launcher',
      vibrationPattern: vibrationPattrn ?? vibrationPattern,
      visibility: NotificationVisibility.public,
      enableLights: true,
      color: const Color(0xFFFFCA28),
      ledColor: const Color.fromARGB(255, 255, 255, 255),
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, 
      iOS: iOSPlatformChannelSpecifics
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      notificationModel.id,
      notificationModel.title,
      notificationModel.body,
      dateTime,
      platformChannelSpecifics,
      payload: notificationModel.payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: daily ? DateTimeComponents.time : null,
    );

  }

  Future<void> cancelSchedule(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> showGroupedNotifications(
      ) async {
    var groupKey = 'com.avoprojects.restaurant_app2.WORK_EMAIL';

    var firstNotificationAndroidSpecifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey);
    var firstNotificationPlatformSpecifics =
        NotificationDetails(android: firstNotificationAndroidSpecifics, iOS: null);
    await _flutterLocalNotificationsPlugin.show(1, 'Alex Faarborg',
        'You will not believe...', firstNotificationPlatformSpecifics);

    var secondNotificationAndroidSpecifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey);
    var secondNotificationPlatformSpecifics =
        NotificationDetails(android: secondNotificationAndroidSpecifics, iOS: null);
    await _flutterLocalNotificationsPlugin.show(
        2,
        'Jeff Chang',
        'Please join us to celebrate the...',
        secondNotificationPlatformSpecifics);

    var lines = <String>[];
    lines.add('Alex Faarborg  Check this out');
    lines.add('Jeff Chang    Launch Party');

    var inboxStyleInformation = InboxStyleInformation(lines,
        contentTitle: '2 messages', summaryText: 'janedoe@example.com');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDesc,
        styleInformation: inboxStyleInformation,
        groupKey: groupKey,
        setAsGroupSummary: true);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: null);
    await _flutterLocalNotificationsPlugin.show(
        3, 'Attention', 'Two messages', platformChannelSpecifics);
  }
 
}