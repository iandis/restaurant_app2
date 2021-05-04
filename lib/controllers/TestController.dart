
import 'package:get/get.dart';
import 'package:restaurant_app2/models/_models.dart';
import 'package:restaurant_app2/services/_services.dart';

class TestController extends GetxController{
  NotificationService notificationService;
  var title = 'Test Notification Service'.obs;

  @override
  void onInit() {
    notificationService = Get.find();
    super.onInit();
  }

  void initWidget(void Function(NotificationModel) onData){
    notificationService.configureDidReceiveLocalNotificationSubject(onData);
  }
}