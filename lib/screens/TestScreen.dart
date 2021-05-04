
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app2/models/Notification/NotificationModel.dart';

import 'package:timezone/timezone.dart' as tz;
import '../AppRouter.dart';
import '../controllers/_controllers.dart';

class TestScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GetX<TestController>(
      initState: (state) {
        state.controller.initWidget((notificationModel) async {
          await Get.toNamed(AppRoutes.testScreen);
        });
      },
      builder: (controller){
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.title.value),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () async => 
                  await controller.notificationService.scheduleNotification(
                    dateTime: tz.TZDateTime.now(tz.local).add(Duration(seconds: 2)),
                    notificationModel: NotificationModel(
                      id: 0,
                      title: 'Test Notification Service',
                      body: 'This is test!\nYhahaha',
                      payload: 'Anjayani',
                    )
                  ), 
                child: Text('Test Notification Service'),
              ),
            ],
          ),
        );
      },
    );
  }

}